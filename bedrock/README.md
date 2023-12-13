# bedrock

A Wing library for working with [Amazon Bedrock](https://aws.amazon.com/bedrock/).

## Prerequisites

* [winglang](https://winglang.io).
* [Model access](https://docs.aws.amazon.com/bedrock/latest/userguide/model-access.html) to Amazon bedrock

## Installation

```sh
npm i @winglibs/bedrock
```

## Usage

```js
bring bedrock;

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
```

## Development

When running in the simulator, set `BEDROCK_DEV=1` to send requests to Amazon Bedrock instead of
replying with a mock response.

## Maintainers

[@eladb](https://github.com/eladb), [@ekeren](https://github.com/ekeren)

## License

This library is licensed under the [MIT License](./LICENSE).
