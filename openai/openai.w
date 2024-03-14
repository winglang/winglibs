bring util;
bring "./api.w" as api;
bring "./utils.w" as utils;
bring cloud;

pub class OpenAI impl api.IOpenAI {
  apiKey: cloud.Secret?;
  org: cloud.Secret?;
  keyOverride: str?;
  orgOverride: str?;

  inflight openai: api.IOpenAI;
  
  new (apiKey: str?, org: str?, apiKeySecret: cloud.Secret?, orgSecret: cloud.Secret?) {
    this.apiKey = apiKeySecret;
    this.org = orgSecret;
    this.keyOverride = apiKey;
    this.orgOverride = org;
  }

  inflight new() {
    // I wanted to write this thing like this:
    // let apiKey: str? = this.keyOverride ?? this.apiKey?.value();
    // I was even willing to settle for this:
    // let apiKey: str? = this.keyOverride ?? this.apiKey?.value();
    // But neither of those work. So I'm doing this instead after opening issue https://github.com/winglang/wing/issues/5944:
    let var apiKey = this.keyOverride;
    if (apiKey == nil){
      apiKey = this.apiKey?.value();
    }
    if (apiKey == nil || apiKey == ""){
      throw "OpenAI API key is required";
    }
    let var org: str? = this.orgOverride;
    if (org == nil){
      org = this.org?.value();
    }
    
    this.openai = utils.createNewInflightClient(apiKey!, org);
  }

  pub inflight createCompletion(prompt: str, params: api.CompletionParams?): str {
    return this.openai.createCompletion(prompt, params);
  }
}
