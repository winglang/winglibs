bring expect;
bring "./openai.w" as openai;

let client = new openai.OpenAI();

// This test currently doesn't pass because of issue https://github.com/winglang/wing/issues/5948 
// test "cant create client without key" {
//   let var errorMessage = "";
//   try {
//     let answer = client.createCompletion("tell me a short joke");
//   } catch e {
//     errorMessage = e;
//   }
//   expect.equal(errorMessage, "OpenAI API key is required");
// }

// This test currently cannot pass because we can't pass credentials to it in the test runner
// test "basic completion" {
//   let answer = client.createCompletion("tell me a short joke");
//   expect.notNil(answer);
// }
