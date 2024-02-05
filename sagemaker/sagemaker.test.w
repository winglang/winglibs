bring expect;
bring "./sagemaker.w" as sageMaker;
bring util;

let sm = new sageMaker.Endpoint(util.tryEnv("ENDPOINT_NAME") ?? "Example-endopint", util.tryEnv("INFERENCE_NAME") ?? "Example-inference");


test "testing endpoint" {
  let res = sm.invoke( { inputs: "Hello there!" }, { ContentType: "application/json" });

  log(Json.stringify(res));
}
