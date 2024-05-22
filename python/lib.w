bring cloud;
bring util;
bring "constructs" as construct;
bring "./types.w" as types;
bring "./sim" as sim;
bring "./sim/api_onrequest_inflight.w" as simapi;
bring "./tfaws/inflight.w" as aws;
bring "./tfaws/api_onrequest_inflight.w" as tfawsapi;

pub class InflightFunction impl cloud.IFunctionHandler {
  _inflightType: str;
  inner: types.IInflight;

  new(props: types.InflightProps) {
    this._inflightType = "_inflightPython";

    let target = util.env("WING_TARGET");
    if target == "sim" {
      this.inner = new sim.Inflight(props);
    } elif target == "tf-aws" {
      this.inner = new aws.Inflight_tfaws(props);
    } else {
      throw "Unsupported target ${target}";
    }
  }

  pub inflight handle(event: str?): str? {
    return this.inner.handle(event);
  }

  pub lift(obj: std.Resource, options: types.LiftOptions): cloud.IFunctionHandler {
    this.inner.lift(obj, options);
    return this;
  }
}

pub class InflightQueueConsumer impl cloud.IQueueSetConsumerHandler {
  _inflightType: str;
  inner: types.IInflight;

  new(props: types.InflightProps) {
    this._inflightType = "_inflightPython";

    let target = util.env("WING_TARGET");
    if target == "sim" {
      this.inner = new sim.Inflight(props);
    } elif target == "tf-aws" {
      this.inner = new aws.Inflight_tfaws(props);
    } else {
      throw "Unsupported target ${target}";
    }
  }

  pub inflight handle(message: str): void {
    this.inner.handle(message);
  }

  pub lift(obj: std.Resource, options: types.LiftOptions): cloud.IQueueSetConsumerHandler {
    this.inner.lift(obj, options);
    return this;
  }
}

pub class InflightTopicOnMessage impl cloud.ITopicOnMessageHandler {
  _inflightType: str;
  inner: types.IInflight;

  new(props: types.InflightProps) {
    this._inflightType = "_inflightPython";

    let target = util.env("WING_TARGET");
    if target == "sim" {
      this.inner = new sim.Inflight(props);
    } elif target == "tf-aws" {
      this.inner = new aws.Inflight_tfaws(props);
    } else {
      throw "Unsupported target ${target}";
    }
  }

  pub inflight handle(message: str): void {
    this.inner.handle(message);
  }

  pub lift(obj: std.Resource, options: types.LiftOptions): cloud.ITopicOnMessageHandler {
    this.inner.lift(obj, options);
    return this;
  }
}

pub class InflightBucketEvent impl cloud.IBucketEventHandler {
  _inflightType: str;
  inner: types.IBucketEventInflight;

  new(props: types.InflightProps) {
    this._inflightType = "_inflightPython";

    let target = util.env("WING_TARGET");
    if target == "sim" {
      this.inner = new sim.BucketEventInflight(props);
    } elif target == "tf-aws" {
      this.inner = new aws.Inflight_tfaws(props);
    } else {
      throw "Unsupported target ${target}";
    }
  }

  pub inflight handle(message: str, type: cloud.BucketEventType): void {
    this.inner.handle(message, type);
  }

  pub lift(obj: std.Resource, options: types.LiftOptions): cloud.IBucketEventHandler {
    this.inner.lift(obj, options);
    return this;
  }
}

pub class InflightApiEndpointHandler impl cloud.IApiEndpointHandler {
  _inflightType: str;
  inner: types.IApiOnRequest;

  new(props: types.InflightProps) {
    this._inflightType = "_inflightPython";

    let target = util.env("WING_TARGET");
    if target == "sim" {
      this.inner = new simapi.InflightApiEndpointHandler(props);
    } elif target == "tf-aws" {
      this.inner = new tfawsapi.InflightApiEndpointHandler_aws(props);
    } else {
      throw "Unsupported target ${target}";
    }
  }

  pub inflight handle(req: cloud.ApiRequest): cloud.ApiResponse? {
    return this.inner.handle(req);
  }

  pub lift(obj: std.Resource, options: types.LiftOptions): InflightApiEndpointHandler {
    this.inner.lift(obj, options);
    return this;
  }
}
