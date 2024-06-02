bring aws;
bring util;
bring ui;
bring "./dynamodb-types.w" as dynamodb_types;
bring "./dynamodb.sim.w" as dynamodb_sim;
bring "./dynamodb.tf-aws.w" as dynamodb_tfaws;

pub class Table impl dynamodb_types.ITable {
  implementation: dynamodb_types.ITable;

  pub connection: dynamodb_types.Connection;
  pub tableName: str;
  pub adminEndpoint: str?;

  new(props: dynamodb_types.TableProps) {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      let sim = new dynamodb_sim.Table_sim(props);
      this.connection = sim.connection;
      this.tableName = sim.tableName;
      this.adminEndpoint = sim.adminEndpoint;
      this.implementation = sim;
      nodeof(sim).hidden = true;
    } elif target == "tf-aws" {
      let tfaws = new dynamodb_tfaws.Table_tfaws(props);
      this.connection = tfaws.connection;
      this.tableName = tfaws.tableName;
      this.implementation = tfaws;
      nodeof(tfaws).hidden = true;
    } else {
      throw "Unsupported target {target}";
    }

    new ui.Field("Table Name", inflight () => {
      return this.tableName;
    }) as "Table Name";

    if let adminEndpoint = this.adminEndpoint {
      new ui.Field("Admin", inflight () => {
        return "{adminEndpoint}/tables/{this.tableName}";
      }, link: true) as "Admin";
    }

    nodeof(this).icon = "table-cells";
    nodeof(this).color = "sky";
  }

  pub setStreamConsumer(handler: inflight (dynamodb_types.StreamRecord): void, opts: dynamodb_types.StreamConsumerOptions?) {
    this.implementation.setStreamConsumer(handler, opts);
  }

  pub inflight delete(options: dynamodb_types.DeleteOptions): dynamodb_types.DeleteOutput {
    return this.implementation.delete(options);
  }

  pub inflight get(options: dynamodb_types.GetOptions): dynamodb_types.GetOutput {
    return this.implementation.get(options);
  }

  pub inflight put(options: dynamodb_types.PutOptions): dynamodb_types.PutOutput {
    return this.implementation.put(options);
  }

  pub inflight transactWrite(options: dynamodb_types.TransactWriteOptions): dynamodb_types.TransactWriteOutput {
    return this.implementation.transactWrite(options);
  }

  pub inflight scan(options: dynamodb_types.ScanOptions?): dynamodb_types.ScanOutput {
    return this.implementation.scan(options);
  }

  pub inflight query(options: dynamodb_types.QueryOptions): dynamodb_types.QueryOutput {
    return this.implementation.query(options);
  }

  pub inflight readWriteConnection(): dynamodb_types.Connection {
    return this.implementation.readWriteConnection();
  }
}

