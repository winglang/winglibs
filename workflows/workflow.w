bring util;
bring "./platforms/seq" as seq;
bring "./platforms/aws" as aws;
bring "./api.w" as api;

pub class Workflow impl api.IWorkflow {
  inner: api.IWorkflow;

  new(steps: Array<api.Step>) {
    let target = util.env("WING_TARGET");
    if target == "tf-aws" {
      this.inner = new aws.Workflow(steps);
    } else {
      this.inner = new seq.Workflow(steps);
    }
  }

  pub onSuccess(cb: inflight (Json?): void): void {
    this.inner.onSuccess(cb);
  }

  pub onError(cb: inflight (api.Error): void): void {
    this.inner.onError(cb);
  }
  
  pub inflight start(ctx: Json?): void {
    this.inner.start(ctx);
  }

  pub inflight status(): api.Status {
    return this.inner.status();
  }

  pub inflight ctx(): Json {
    return this.inner.ctx();
  }

  pub inflight error(): api.Error? {
    return this.inner.error();
  }

  pub inflight join(opts: util.WaitUntilProps?): Json {
    return this.inner.join(opts);
  }
}