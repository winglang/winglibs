bring aws;
bring util;
bring "./types.w" as types;
bring "./sagemaker.sim.w" as s;
bring "./sagemaker.tfaws.w" as t;

pub class Endpoint impl types.ISageMaker {
  pub endpointName: str;


  inner: types.ISageMaker;

  new(endpointName: str, inferenceComponentName: str) {
    this.endpointName = endpointName;


    let target = util.env("WING_TARGET");
    if target == "sim" {
      if nodeof(this).app.isTestEnvironment {
        // in case of test running on sim, use simulator version
        this.inner = new s.SageMaker_sim(endpointName, inferenceComponentName) as "sim"; 
      } else {
        // in case of running on sim interactively (in development mode), use AWS version
        this.inner = new t.SageMaker_tfaws(endpointName, inferenceComponentName) as "tf-aws";  
      }
    } elif target == "tf-aws" {
      this.inner = new t.SageMaker_tfaws(endpointName, inferenceComponentName) as "tf-aws";
    } else {
      throw "Unsupported target {target}";
    }
  }

  pub inflight invoke(body: Json, options: types.InvocationOptions?): types.InvocationOutput {
    return this.inner.invoke(body, options);
  }
}

