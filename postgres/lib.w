bring aws;
bring cloud;
bring containers;
bring http;
bring util;
bring "constructs" as constructs;
bring "cdktf" as cdktf;
bring "@rybickic/cdktf-provider-neon" as rawNeon;
bring "@cdktf/provider-aws" as tfaws;

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
}

pub class Database {
  inner: IDatabase;
  new(props: DatabaseProps) {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      this.inner = new DatabaseSim(props);
    } elif target == "tf-aws" {
      this.inner = new DatabaseNeon(props);
    } else {
      throw "Unsupported target: " + target;
    }
  }

  pub inflight query(query: str): Array<Map<Json>> {
    return this.inner.query(query);
  }
}

class DatabaseSim impl IDatabase {
  url: str?;
  new(props: DatabaseProps) {
    let image = "postgres:${props.pgVersion ?? 15}";
    let container = new containers.Workload(
      name: "postgres",
      image: image,
      env: {
        POSTGRES_PASSWORD: "password"
      },
      port: 5432,
      public: true,
    );
    this.url = container.getPublicUrl();
  }

  pub inflight query(query: str): Array<Map<Json>> {
    let port = num.fromStr(http.parseUrl(this.url ?? "error").port);
    return PgUtil._query(query, {
      host: "localhost",
      password: "password",
      database: "postgres",
      user: "postgres",
      port: port,
      ssl: false,
    });
  }
}

struct DbCredentials {
  host: str;
  user: str;
  password: str;
  database: str;
}

class DatabaseNeon impl IDatabase {
  creds: cloud.Secret;

  new(props: DatabaseProps) {
    this.neonProvider();

    // TODO: share a project between multiple databases
    let project = new rawNeon.project.Project(
      name: props.name,
      pgVersion: props.pgVersion ?? 15,
    );

    let db = new rawNeon.database.Database(
      projectId: project.id,
      branchId: project.defaultBranchId,
      ownerName: project.databaseUser,
      name: props.name,
    );

    this.creds = new cloud.Secret() as "NeonCredentials";

    // TODO: avoid hard-coding for AWS
    let secretsManagerSecret: tfaws.secretsmanagerSecret.SecretsmanagerSecret = unsafeCast(this.creds.node.findChild("Default"));
    let secretVersion = new tfaws.secretsmanagerSecretVersion.SecretsmanagerSecretVersion(
      secretId: secretsManagerSecret.id,
      secretString: cdktf.Fn.jsonencode({
        host: project.databaseHost,
        user: project.databaseUser,
        password: project.databasePassword,
        database: project.databaseName,
      })
    ) as "NeonCredentialsVersion";
  }

  neonProvider(): cdktf.TerraformProvider {
    let stack = cdktf.TerraformStack.of(this);
    let singletonKey = "WingNeonProvider";
    let existing = stack.node.tryFindChild(singletonKey);
    if existing? {
      return unsafeCast(existing);
    }

    return new rawNeon.provider.NeonProvider() as singletonKey in stack;
  }

  pub inflight query(query: str): Array<Map<Json>> {
    let creds = DbCredentials.fromJson(this.creds.valueJson());
    return PgUtil._query(query, {
      host: creds.host,
      user: creds.user,
      password: creds.password,
      database: creds.database,
      ssl: true,
    });
  }
}

struct ConnectionOptions {
  host: str;
  port: num?; // default: 5432
  user: str;
  password: str;
  database: str;
  ssl: bool;
}

class PgUtil {
  pub extern "./pg.js" static inflight _query(query: str, creds: ConnectionOptions): Array<Map<Json>>;
}
