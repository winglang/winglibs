bring "./bedrock.w" as bedrock;

pub class JokeMaker {
  claud: bedrock.Model;

  new() {
    this.claud = new bedrock.Model("anthropic.claude-v2") as "claude";
  }

  pub inflight makeJoke(topic: str): str {
    let res = this.claud.invoke({
      prompt: "\n\nHuman: Tell me a joke about {topic}\n\nAssistant:",
      max_tokens_to_sample: 300,
      temperature: 0.5,
      top_k: 250,
      top_p: 1,
      stop_sequences: [
        "\n\nHuman:"
      ],
      anthropic_version: "bedrock-2023-05-31"
    });

    return res.get("completion").asStr();
  }
}