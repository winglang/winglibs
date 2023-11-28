bring "./api.w" as b;

pub class Model_sim impl b.IModel {
  modelId: str;
  var mockResponse: inflight (Json): Json;

  new(modelId: str) {
    this.modelId = modelId;
    this.mockResponse = inflight (body) => {
      return {
        response: "We are living in a simulation",
        model: this.modelId,
        request: body,
      };
    };
  }

  pub setMockResponse(fn: inflight (Json): Json) {
    this.mockResponse = fn;
  }

  pub inflight invoke(body: Json): Json {
    return this.mockResponse(body);
  }
}