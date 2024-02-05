bring expect;
bring "./sagemaker.w" as sageMaker;
bring util;

let sm = new sageMaker.Endpoint(util.env("ENDPOINT_NAME"), util.env("INFERENCE_NAME"));


test "testing endpoint" {
  let res = sm.invoke( { inputs: "Hello there!" }, { ContentType: "application/json" });

  log(Json.stringify(res));
}
