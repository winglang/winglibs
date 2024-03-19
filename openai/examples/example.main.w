bring expect;
bring "../openai.w" as openai;

bring cloud;

let oai = new openai.OpenAI(apiKey: "my-openai-key");

new cloud.Function(inflight () => {
  let answer = oai.createCompletion("tell me a short joke", model: "gpt-3.5-turbo", maxTokens: 2048);
  log(answer);
}) as "tell me a joke";
