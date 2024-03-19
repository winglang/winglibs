bring "./api.w" as api;

pub class Util {
  extern "./openai.js" pub static inflight createNewInflightClient(apiKey: str, org: str?): api.IOpenAI;
}