bring aws;
bring util;
bring "./dynamodb-types.w" as dynamodb_types;
bring "./dynamodb.sim.w" as dynamodb_sim;
bring "./dynamodb.tf-aws.w" as dynamodb_tfaws;

pub class Table impl dynamodb_types.ITable {
  implementation: dynamodb_types.ITable;

  new(props: dynamodb_types.TableProps) {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      this.implementation = new dynamodb_sim.Table_sim(props);
    } elif target == "tf-aws" {
      this.implementation = new dynamodb_tfaws.Table_tfaws(props);
    } else {
      throw "Unsupported target {target}";
    }
  }

  pub connection(): dynamodb_types.Connection {
    return this.implementation.connection();
  }

  pub setStreamConsumer(handler: inflight (dynamodb_types.StreamRecord): void, options: dynamodb_types.StreamConsumerOptions?) {
    this.implementation.setStreamConsumer(handler, options);
  }

  pub onInsert(handler: inflight (dynamodb_types.StreamRecord): void, options: dynamodb_types.StreamConsumerOptions?) {
    this.implementation.onInsert(handler, options);
  }

  pub onUpdate(handler: inflight (dynamodb_types.StreamRecord): void, options: dynamodb_types.StreamConsumerOptions?) {
    this.implementation.onUpdate(handler, options);
  }

  pub onDelete(handler: inflight (dynamodb_types.StreamRecord): void, options: dynamodb_types.StreamConsumerOptions?) {
    this.implementation.onDelete(handler, options);
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

  pub inflight update(options: dynamodb_types.UpdateOptions): dynamodb_types.UpdateOutput {
    return this.implementation.update(options);
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
}

