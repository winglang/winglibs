bring "./joke.w" as j;
bring "./bedrock.sim.w" as s;
bring util;

let joke = new j.JokeMaker();

// an experimental pattern for mocking responses
// this will only kick in if is in sim and test mode
if util.env("WING_TARGET") == "sim" && std.Node.of(joke).app.isTestEnvironment {
  let model = std.Node.of(joke).findChild("claude").node.findChild("sim");
  let sim: s.Model_sim = unsafeCast(model);
  sim.setMockResponse(inflight (body) => {
    return {
      completion: " Here's a silly joke about oranges:\n\nHow does an orange ask another orange to dance?\n\"Hey orange, want to grab a peeling and tango?\"",
      stop_reason: "stop_sequence",
      stop: "\n\nHuman:"
    };
  });
}

test "make a joke" {
  let res = joke.makeJoke("oranges");
  log(res);
}