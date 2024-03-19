bring util;
bring "./api.w" as api;
bring "./utils.w" as utils;
bring cloud;

pub struct OpenAIProps {
  apiKey: str?;
  org: str?;
  apiKeySecret: cloud.Secret?;
  orgSecret: cloud.Secret?;
}

inflight class Sim impl api.IOpenAI {
  pub createCompletion(prompt: str, params: api.CompletionParams?): str {
    return Json.stringify({ mock: { prompt: prompt, params: params } });
  }
}

pub class OpenAI impl api.IOpenAI {
  apiKey: cloud.Secret?;
  org: cloud.Secret?;
  keyOverride: str?;
  orgOverride: str?;

  mock: bool;

  inflight openai: api.IOpenAI;
  
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
      this.openai = utils.createNewInflightClient(apiKey, org);
    }
  }

  pub inflight createCompletion(prompt: str, params: api.CompletionParams?): str {
    return this.openai.createCompletion(prompt, params);
  }
}
