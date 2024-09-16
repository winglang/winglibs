bring "./resource.w" as tf;
bring util;

if util.env("WING_TARGET").startsWith("tf") {
  let role = new tf.Resource({
    terraformResourceType: "aws_iam_role",
    attributes: {
      inline_policy: {
        name: "lambda-invoke",
        policy: Json.stringify({
          Version: "2012-10-17",
          Statement: [ 
            { Effect: "Allow", Action: [ "lambda:InvokeFunction" ], Resource: "*" }
          ]
        })
      },
      assume_role_policy: Json.stringify({
        Version: "2012-10-17",
        Statement: [
          { Action: "sts:AssumeRole", Effect: "Allow", Principal: { Service: "states.amazonaws.com" } },
        ]
      })
    }
  }) as "my_role";
  
  let arn = role.getStringAttribute("arn");
  
  test "print arn" {
    log(arn);
  }
}
