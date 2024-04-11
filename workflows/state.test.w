bring "./state.w" as s;
bring expect;

let state = new s.State();

test "starts with an empty object" {
  expect.equal(state.get(), {});
  expect.equal(state.getError(), nil);
}

test "can set and get a value" {
  state.set({ hello: 123 });
  expect.equal(state.get(), { hello: 123 });
}

test "can get and set an error" {
  state.setError("Something went wrong");
  expect.equal(state.getError(), "Something went wrong");
}