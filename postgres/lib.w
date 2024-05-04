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
  inflight connectionOptions(): ConnectionOptions;
}

pub class Database {
  pub connection: ConnectionOptions;
  inner: IDatabase;
  new(props: DatabaseProps) {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      let sim = new DatabaseSim(props);
      this.connection = sim.connection;
      this.inner = sim;
    } elif target == "tf-aws" {
      let neon = new DatabaseNeon(props);
      this.connection = neon.connection;
      this.inner = neon;
    } else {
      throw "Unsupported target: " + target;
    }
  }

  pub inflight query(query: str): Array<Map<Json>> {
    return this.inner.query(query);
  }
  pub inflight connectionOptions(): ConnectionOptions  {
    return this.inner.connectionOptions();
  }
}

class DatabaseSim impl IDatabase {
  port: str;

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
      log("waiting for port {container.hostPort!} to open...");

      util.waitUntil(() => {
        log("ping...");
        return PgUtil.isPortOpen(container.hostPort!);
      });

      log("postgres port {container.hostPort!} is open");
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

    new ui.ValueField("Postgres Port", this.port);
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
    let existing = stack.node.tryFindChild(singletonKey);
    if existing? {
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
  pub extern "./util.ts" static inflight isPortOpen(port: str): bool;
}
