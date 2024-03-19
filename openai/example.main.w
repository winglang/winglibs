bring expect;
bring "./openai.w" as openai;

bring cloud;

let key = new cloud.Secret(name: "my-openai-key");
let oai = new openai.OpenAI(apiKeySecret: key);

new cloud.Function(inflight () => {
  let answer = oai.createCompletion("tell me a short joke", model: "gpt-3.5-turbo", maxTokens: 2048);
  log(answer);
}) as "tell me a joke";
