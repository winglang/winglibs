bring cloud;
bring expect;
bring "./sagemaker.w" as sageMaker;
bring util;

let sm = new sageMaker.Endpoint(util.tryEnv("ENDPOINT_NAME") ?? "Example-endopint", util.tryEnv("INFERENCE_NAME") ?? "Example-inference");

let invokeModel = inflight (input: Json?) => {
  let var s = input?.tryAsStr() ?? "Hi There!";
  let res = sm.invoke( { inputs: "{s}" }, { ContentType: "application/json" });
  log(res.Body);
};

new cloud.Function(invokeModel);

test "main" {
    invokeModel("Hello there!");
}
