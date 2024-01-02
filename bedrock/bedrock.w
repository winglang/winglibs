bring aws;
bring util;
bring "./api.w" as a;
bring "./bedrock.sim.w" as s;
bring "./bedrock.tfaws.w" as t;

pub class Model impl a.IModel {
  pub modelId: str;

  inner: a.IModel;

  new(modelId: str) {
    this.modelId = modelId;

    let target = util.env("WING_TARGET");
    if target == "sim" {
      if std.Node.of(this).app.isTestEnvironment {
        // in case of test running on sim, use simulator version
        this.inner = new s.Model_sim(modelId) as "sim"; 
      } else {
        // in case of running on sim interactively (in development mode), use AWS version
        this.inner = new t.Model_tfaws(modelId) as "tf-aws";  
      }
    } elif target == "tf-aws" {
      this.inner = new t.Model_tfaws(modelId) as "tf-aws";
    } else {
      throw "Unsupported target {target}";
    }
  }

  pub inflight invoke(body: Json): Json {
    return this.inner.invoke(body);
  }
}

