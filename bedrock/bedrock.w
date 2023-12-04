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
    let dev = util.tryEnv("BEDROCK_DEV");
    if target == "sim" && !dev? {
      this.inner = new s.Model_sim(modelId) as "sim";
    } elif target == "tf-aws" || dev? {
      this.inner = new t.Model_tfaws(modelId) as "tf-aws";
    } else {
      throw "Unsupported target {target}";
    }
  }

  pub inflight invoke(body: Json): Json {
    return this.inner.invoke(body);
  }
}

