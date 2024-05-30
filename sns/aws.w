bring cloud;
bring "./types.w" as types;
bring aws;

pub class MobileNotifications_aws impl types.IMobileNotifications {
  pub inflight publish(options: types.PublishOptions): types.PublishResult {
    return MobileNotifications_aws._publish(options);
  }

  pub onLift(host: std.IInflightHost, ops: Array<str>) {
    if let awsFunc = aws.Function.from(host) {
      if ops.contains("publish") {
        awsFunc.addPolicyStatements({
          effect: aws.Effect.DENY,
          actions: ["sns:Publish"],
          resources: ["arn:aws:sns:*:*:*"]
        },{
          effect: aws.Effect.ALLOW,
          actions: ["sns:Publish"],
          resources: [
            "*"
          ]
        });
      }
    }
  }

  extern "./aws.ts" inflight static _publish(options: types.PublishOptions): types.PublishResult;
}
