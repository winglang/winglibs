pub struct CompletionParams {
  model: str;
  max_tokens: num;
}

// TODO: need to recreate the openai interface with higher fidelity
pub interface IOpenAI {
  inflight createCompletion(prompt: str, params: CompletionParams?): str;
}
