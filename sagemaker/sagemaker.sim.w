bring "./types.w" as types;

pub class SageMaker_sim impl types.ISageMaker {
  endpointName: str;
  inferenceName: str;
  var mockResponse: inflight (Json, types.invocationOptions? ): types.invocationOutput;

  new(endpointName: str, inferenceName: str) {
    this.endpointName = endpointName;
    this.inferenceName = inferenceName;
    this.mockResponse = inflight (body: Json, options: types.invocationOptions? ) => {
      return {
        Body: "This is an example"       
      };
    };
  }

  pub setMockResponse(fn: inflight (Json, types.invocationOptions? ): types.invocationOutput) {
    this.mockResponse = fn;
  }

  pub inflight invoke(body: Json, options: types.invocationOptions? ): types.invocationOutput {
    return this.mockResponse(body, options);
  }
}