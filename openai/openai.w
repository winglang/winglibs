bring cloud;
bring util;

pub struct CompletionParams {
  model: str?;
  maxTokens: num?;
}

pub struct OpenAIProps {
  apiKey: str?;
  org: str?;
  apiKeySecret: cloud.Secret?;
  orgSecret: cloud.Secret?;
}

inflight interface IClient {
  inflight createCompletion(params: Json): Json;
}

inflight class Sim impl IClient {
  pub createCompletion(req: Json): Json {
    return {
      choices: [
        {
          message: {
            content: Json.stringify({ mock: req })
          }
        }
      ]
    };
  }
}

pub class OpenAI {
  apiKey: cloud.Secret?;
  org: cloud.Secret?;
  keyOverride: str?;
  orgOverride: str?;

  mock: bool;

  inflight openai: IClient;

  new(props: OpenAIProps?) {
    this.apiKey = props?.apiKeySecret;
    this.org = props?.orgSecret;
    this.keyOverride = props?.apiKey;
    this.orgOverride = props?.org;
    this.mock = util.env("WING_TARGET") == "sim" && nodeof(this).app.isTestEnvironment;
  }

  inflight new() {
    // TODO: https://github.com/winglang/wing/issues/5944
    let UNDEFINED = "<UNDEFINED>";
    let apiKey = this.keyOverride ?? this.apiKey?.value() ?? UNDEFINED;
    if apiKey == UNDEFINED {
      throw "Either `apiKeySecret` or `apiKey` are required";
    }

    let var org: str? = this.orgOverride;
    if org == nil {
      org = this.org?.value();
    }

    if this.mock {
      this.openai = new Sim();
    } else {
      this.openai = OpenAI.createNewInflightClient(apiKey, org);
    }
  }

  pub inflight createCompletion(prompt: str, params: CompletionParams?): str {
    let resp = this.openai.createCompletion({
      max_tokens: params?.maxTokens ?? 2048,
      model: params?.model ?? "gpt-3.5-turbo",
      messages: [ { role: "user", content: prompt } ]
    });

    return resp["choices"][0]["message"]["content"].asStr();
  }

  extern "./openai.js" pub static inflight createNewInflightClient(apiKey: str, org: str?): IClient;
}
