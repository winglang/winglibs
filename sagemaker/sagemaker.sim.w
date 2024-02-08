bring "./types.w" as types;

pub class SageMaker_sim impl types.ISageMaker {
  endpointName: str;
  inferenceName: str;
  var mockResponse: inflight (Json, types.InvocationOptions? ): types.InvocationOutput;

  new(endpointName: str, inferenceName: str) {
    this.endpointName = endpointName;
    this.inferenceName = inferenceName;
    this.mockResponse = inflight (body: Json, options: types.InvocationOptions? ) => {
      return {
        Body: "This is an example"       
      };
    };
  }

  pub setMockResponse(fn: inflight (Json, types.InvocationOptions? ): types.InvocationOutput) {
    this.mockResponse = fn;
  }

  pub inflight invoke(body: Json, options: types.InvocationOptions? ): types.InvocationOutput {
    return this.mockResponse(body, options);
  }
}