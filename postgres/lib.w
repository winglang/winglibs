bring aws;
bring cloud;
bring http;
bring util;
bring sim;
bring ui;
bring "constructs" as constructs;
bring "cdktf" as cdktf;
bring "@rybickic/cdktf-provider-neon" as rawNeon;
bring "@cdktf/provider-aws" as tfaws;

pub struct AwsParameters {
  postgresEngine: str?;
}

pub struct ConnectionOptions {
  host: str;
  port: str;
  user: str;
  password: str;
  database: str;
  ssl: bool;
}

pub struct DatabaseProps {
  /**
   * The database name.
   */
  name: str;
  /**
   * The postgres version.
   * @default 15
   */
  pgVersion: num?;
}

pub interface IDatabase {
  inflight query(query: str): Array<Map<Json>>;
  inflight connectionOptions(): ConnectionOptions?;
}

struct RequiredTFAwsProps {
  /**
  * Supported: [neon, rds]
  */
  postgresEngine: str;
}

struct RequiredRDSParameters {
  instanceCount: num;
  /**
   * See: https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.html 
   */
  instanceClass: str;
  /** Deault postgres */
  masterUsername: str?;
}

struct AWSDatabaseRefParameters {
  vpcId: str;
}

pub class DatabaseRef {
  connectionSecret: cloud.Secret;

  new() {
    // For database refs, we just need to have a secret connection string to use for queries
    this.connectionSecret = new cloud.Secret(name: "connectionString_{nodeof(this).id}");

    let target = util.env("WING_TARGET");
    if target == "tf-aws" {
      let params = nodeof(this).app.parameters;

      let allParams = params.read();
      if !allParams.has("tf-aws") {
        // TODO: find a good way to enforce this with parameters. (currently cant duplicate required params schemas)
        log("WARNING: Unless your database is accessible from the public internet, you must provide vpc info under `tf-aws` in your wing.toml file\nFor more info see: https://www.winglang.io/docs/platforms/tf-aws#parameters");
      }
    }
  }

  pub inflight query(query: str): Array<Map<Json>> {
    return PgUtil._queryWithConnectionString(query, this.connectionSecret.value());
  }
}

pub class Database {
  pub connection: ConnectionOptions;
  inner: IDatabase;
  new(props: DatabaseProps) {
    let app = nodeof(this).app;
    let params = app.parameters.read(schema: AwsParameters.schema());

    let target = util.env("WING_TARGET");
    if target == "sim" {
      let sim = new DatabaseSim(props);
      this.connection = sim.connection;
      this.inner = sim;
      new ui.ValueField("Port", sim.port) as "port";
      
      new ui.Field("Connection", inflight () => {
        return "postgresql://{sim.connection.user}:{sim.connection.password}@localhost:{sim.port}/{sim.connection.database}";
      }, link: true) as "connection";

      nodeof(sim).hidden = true;
    } elif target == "tf-aws" {
      let tfawsParams = RequiredTFAwsProps.fromJson(app.parameters.read(schema: RequiredTFAwsProps.schema()));
      if tfawsParams.postgresEngine == "rds" {
        let aurora = new DatabaseRDS(props);
        this.connection = aurora.connection;
        this.inner = aurora;
      } elif tfawsParams.postgresEngine == "neon" {
        let neon = new DatabaseNeon(props);
        this.connection = neon.connection;
        this.inner = neon;
      } else {
        throw "Unsupported postgres engine for tf-aws: " + tfawsParams.postgresEngine;
      }
    } else {
      throw "Unsupported target: " + target;
    }

    nodeof(this).icon = "table-cells";
    nodeof(this).color = "purple";
  }

  pub inflight query(query: str): Array<Map<Json>> {
    return this.inner.query(query);
  }
  pub inflight connectionOptions(): ConnectionOptions  {
    return this.inner.connectionOptions()!;
  }
}

struct TfawsApp {
  vpc: tfaws.vpc.Vpc;
  subnets: TfawsAppSubnets;
}

struct TfawsAppSubnets {
  private: Array<tfaws.subnet.Subnet>;
  public: Array<tfaws.subnet.Subnet>;
}

class DatabaseRDS impl IDatabase {
  var secretRef: aws.SecretRef;
  var endpoint: str;
  params: RequiredRDSParameters;
  databaseName: str;
  pub connection: ConnectionOptions;

  new (props: DatabaseProps) {
    this.databaseName = props.name;

    let app = nodeof(this).app;
    this.params = RequiredRDSParameters.fromJson(app.parameters.read(schema: RequiredRDSParameters.schema()));
    let tfawsApp: TfawsApp = unsafeCast(nodeof(this).app);
    let vpc = tfawsApp.vpc;
    let subnetIds: MutArray<str> = MutArray<str>[];

    let sg = new tfaws.securityGroup.SecurityGroup(
      vpcId: vpc.id,
      egress: [
        {
          fromPort: 0,
          toPort: 0,
          protocol: "-1",
          cidrBlocks: ["0.0.0.0/0"]
        }
      ],
      ingress: [
        {
          fromPort: "5432",
          toPort: "5432",
          protocol: "tcp",
          cidrBlocks: ["0.0.0.0/0"]
        }
      ]
    );

    for net in tfawsApp.subnets.private {
      subnetIds.push(net.id);
    }

    let subnetGroup = new tfaws.dbSubnetGroup.DbSubnetGroup(
      subnetIds: subnetIds.copy()
    );

    let cluster = new tfaws.rdsCluster.RdsCluster(
      engine: "aurora-postgresql",
      databaseName: this.databaseName,
      masterUsername: this.params.masterUsername ?? "postgres",
      manageMasterUserPassword: true,
      dbSubnetGroupName: subnetGroup.name,
      vpcSecurityGroupIds: [sg.id]
    );

    for i in 0..this.params.instanceCount {
      new tfaws.rdsClusterInstance.RdsClusterInstance(
        clusterIdentifier: cluster.id,
        instanceClass: this.params.instanceClass,
        engine: cluster.engine,
        dbSubnetGroupName: subnetGroup.name
      ) as "rdsInstance{i}";
    } 

    let role = new tfaws.iamRole.IamRole(
      assumeRolePolicy: Json.stringify({
        Version: "2012-10-17",
        Statement: [
          {
            Effect: "Allow",
            Principal: {
              Service: "rds.amazonaws.com"
            },
            Action: "sts:AssumeRole"
          }
        ]
      })
    );

    let policy = new tfaws.iamPolicy.IamPolicy(
      policy: Json.stringify({
        Version: "2012-10-17",
        Statement: [
          {
            Action: [
              "secretsmanager:GetSecretValue"
            ],
            Effect: "Allow",
            Resource: cluster.masterUserSecret.get(0).secretArn
          }
        ]
      })
    );

    new tfaws.iamRolePolicyAttachment.IamRolePolicyAttachment(
      policyArn: policy.arn,
      role: role.name
    );

    let proxy = new tfaws.dbProxy.DbProxy(
      name: "proxy{nodeof(this).addr.substring(0, -8)}",
      engineFamily: "POSTGRESQL",
      auth: {
        secret_arn: cluster.masterUserSecret.get(0).secretArn
      },
      vpcSubnetIds: subnetIds.copy(),
      roleArn: role.arn,
      vpcSecurityGroupIds: [ sg.id ]
    );
        
    let targetGroup = new tfaws.dbProxyDefaultTargetGroup.DbProxyDefaultTargetGroup(
      dbProxyName: proxy.name,
    );

    new tfaws.dbProxyTarget.DbProxyTarget(
      dbProxyName: proxy.name,
      dbClusterIdentifier: cluster.id,
      targetGroupName: targetGroup.name
    );

    
    this.endpoint = proxy.endpoint;
    this.secretRef = new aws.SecretRef(cluster.masterUserSecret.get(0).secretArn);
    new cdktf.TerraformOutput(value: cluster.masterUserSecret);

    this.connection = {
      host: proxy.endpoint,
      user: this.params.masterUsername ?? "postgres",
      password: cluster.masterPassword,
      database: this.databaseName,
      ssl: true,
      port: "5432"
    };
  }

  pub inflight query(query: str): Array<Map<Json>> {
    return PgUtil._query(query, this.connectionOptions());
  }

  pub inflight connectionOptions(): ConnectionOptions {
    let databaseSecrets = Json.parse(this.secretRef.value());
    return {
      host: this.endpoint,
      user: databaseSecrets.get("username").asStr(),
      password: databaseSecrets.get("password").asStr(),
      database: this.databaseName,
      ssl: true,
      port: "5432"
    };
  }
}

class DatabaseSim impl IDatabase {
  pub port: str;

  pub connection: ConnectionOptions;

  new(props: DatabaseProps) {
    let image = "postgres:{props.pgVersion ?? 15}";
    let container = new sim.Container(
      name: "postgres",
      image: image,
      env: {
        POSTGRES_PASSWORD: "password"
      },
      containerPort: 5432,
      volumes: ["/var/lib/postgresql/data"],
      // TODO: implement readiness check?
    );

    let state = new sim.State();
    this.port = state.token("port");

    new cloud.Service(inflight () => {
      log("Waiting for Postgres to listen on {container.hostPort!}...");

      util.waitUntil(() => {
        return PgUtil.isPortOpen(container.hostPort!);
      });

      log("Postgres is ready on port {container.hostPort!}");
      state.set("port", container.hostPort!);
    });

    this.connection = {
      host: "localhost",
      password: "password",
      database: "postgres",
      user: "postgres",
      port: this.port,
      ssl: false,
    };
  }

  pub inflight connectionOptions(): ConnectionOptions {
    return this.connection;
  }

  pub inflight query(query: str): Array<Map<Json>> {
    return PgUtil._query(query, this.connection);
  }
}

struct DbCredentials {
  host: str;
  user: str;
  password: str;
  database: str;
}

class DatabaseNeon impl IDatabase {
  pub connection: ConnectionOptions;

  new(props: DatabaseProps) {
    this.neonProvider();

    // TODO: share a project between multiple databases
    let project = new rawNeon.project.Project(
      name: props.name,
      historyRetentionSeconds: 1d.seconds, // Free tier limitation
      pgVersion: props.pgVersion ?? 16,
    );

    let db = new rawNeon.database.Database(
      projectId: project.id,
      branchId: project.defaultBranchId,
      ownerName: project.databaseUser,
      name: props.name,
    );

    this.connection = {
      database: project.databaseName,
      host: project.databaseHost,
      password: project.databasePassword,
      port: "5432",
      ssl: true,
      user: project.databaseUser,
    };
  }

  neonProvider(): cdktf.TerraformProvider {
    let stack = cdktf.TerraformStack.of(this);
    let singletonKey = "WingNeonProvider";
    let existing = nodeof(stack).tryFindChild(singletonKey);
    if existing != nil {
      return unsafeCast(existing);
    }

    return new rawNeon.provider.NeonProvider() as singletonKey in stack;
  }

  pub inflight connectionOptions(): ConnectionOptions {
    return this.connection;
  }

  pub inflight query(query: str): Array<Map<Json>> {
    return PgUtil._query(query, this.connectionOptions());
  }
}

class PgUtil {
  pub extern "./pg.js" static inflight _query(query: str, creds: ConnectionOptions): Array<Map<Json>>;
  pub extern "./pg.js" static inflight _queryWithConnectionString(query: str, connectionString: str): Array<Map<Json>>;
  pub extern "./util.ts" static inflight isPortOpen(port: str): bool;
}
