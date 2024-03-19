bring expect;
bring "./openai.w" as openai;

bring cloud;

let key = new cloud.Secret(name: "my-openai-key");
let oai = new openai.OpenAI(apiKeySecret: key);

test "basic completion" {
  let answer = oai.createCompletion("tell me a short joke", max_tokens: 1024);

  // in tests, the response is just an echo of the request
  expect.equal(answer, Json.stringify({
    mock: {
      prompt:"tell me a short joke",
      params:{"model":"gpt-3.5-turbo","max_tokens":1024}
    }
  }));
}
