bring expect;
bring "./bedrock.w" as bedrock;

let titan = new bedrock.Model("amazon.titan-text-lite-v1") as "titan";
let claude = new bedrock.Model("anthropic.claude-v2") as "claude";

test "titan" {
  let res = titan.invoke({
    inputText: "what is a joke?",
    textGenerationConfig: {
      maxTokenCount: 4096,
      stopSequences: [],
      temperature: 0,
      topP: 1
    }
  });

  log(Json.stringify(res));
}

test "claude" {
  let res = claude.invoke({
    prompt: "\n\nHuman: Hello universe\n\nAssistant:",
    max_tokens_to_sample: 300,
    temperature: 0.5,
    top_k: 250,
    top_p: 1,
    stop_sequences: [
      "\n\nHuman:"
    ],
    anthropic_version: "bedrock-2023-05-31"
  });

  log(Json.stringify(res));
}
