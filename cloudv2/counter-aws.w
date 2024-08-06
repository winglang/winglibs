bring aws;

bring "./counter-types.w" as counter_types;
bring "@cdktf/provider-aws" as tfaws;
bring "./util.w" as myutil;

pub interface IAwsCounter {
  dynamoTableArn(): str; // TODO: support properties on interfaces - https://github.com/winglang/wing/issues/4961
  dynamoTableName(): str;
}

internal class Counter_tfaws impl counter_types.ICounter, IAwsCounter {
  initial: num;
  table: tfaws.dynamodbTable.DynamodbTable;
  hashKey: str;
  defaultKey: str; // TODO: module-level constants - https://github.com/winglang/wing/issues/3606
  envKey: str;
  tableName: str;
  tableArn: str;
  new(props: counter_types.CounterProps) {
    this.initial = props.initial ?? 0;
    this.hashKey = "id";
    this.table = new tfaws.dynamodbTable.DynamodbTable(
      name: myutil.friendlyName(this),
      attribute: [{ name: this.hashKey, type: "S" }],
      hashKey: this.hashKey,
      billingMode: "PAY_PER_REQUEST",
    ) as "Default";
    this.defaultKey = "default";
    this.envKey = "COUNTER_" + myutil.shortHash(this);
    this.tableName = this.table.name;
    this.tableArn = this.table.arn;
  }

  extern "./counter-aws.ts" static inflight _inc(amount: num, key: str, tableName: str, hashKey: str, initial: num): num;
  extern "./counter-aws.ts" static inflight _dec(amount: num, key: str, tableName: str, hashKey: str, initial: num): num;
  extern "./counter-aws.ts" static inflight _peek(key: str, tableName: str, hashKey: str, initial: num): num;
  extern "./counter-aws.ts" static inflight _set(value: num, key: str, tableName: str, hashKey: str): void;

  pub inflight inc(amount: num?, key: str?): num {
    return Counter_tfaws._inc(amount ?? 1, key ?? this.defaultKey, this.tableName, this.hashKey, this.initial);
  }

  pub inflight dec(amount: num?, key: str?): num {
    return Counter_tfaws._dec(amount ?? 1, key ?? this.defaultKey, this.tableName, this.hashKey, this.initial);
  }

  pub inflight peek(key: str?): num {
    return Counter_tfaws._peek(key ?? this.defaultKey, this.tableName, this.hashKey, this.initial);
  }

  pub inflight set(value: num, key: str?): void {
    Counter_tfaws._set(value, key ?? this.defaultKey, this.tableName, this.hashKey);
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    // TODO: implement aws.Host.from
    // if aws.Host.from(host) == nil {
    //   throw "Counter for \"tf-aws\" can only be lifted by a class implementing aws.IHost";
    // }

    // let awsHost: aws.IAwsInflightHost = aws.Host.from(host)!;
    let awsHost: aws.IAwsInflightHost = unsafeCast(host);
    let actions = MutArray<str>[];
    if ops.contains("inc") || ops.contains("dec") || ops.contains("set") {
      actions.push("dynamodb:UpdateItem");
    }
    if ops.contains("peek") {
      actions.push("dynamodb:GetItem");
    }
  
    awsHost.addPolicyStatements({
      actions: actions.copy(),
      effect: aws.Effect.ALLOW,
      resources: [this.tableArn],
    });
    awsHost.addEnvironment(this.envKey, this.tableName);
  }

  pub dynamoTableArn(): str {
    return this.tableArn;
  }

  pub dynamoTableName(): str {
    return this.tableName;
  }
}

// TODO: move this into an "aws" namespace

pub class AwsCounter {
  pub static from(c: counter_types.ICounter): IAwsCounter? {
    let obj = unsafeCast(c);
    if obj?.dynamoTableArn != nil && obj?.dynamoTableName != nil {
      return obj;
    }
    return nil;
  }
}
