const openai = require('openai');

exports.createNewInflightClient = (apiKey, org) => {
  const config = { apiKey };

  if (org) {
    config.organization = org;
  }

  let client = new openai.OpenAI(config);

  // TODO: this is a hack for now, we should model the openai api in the api.w file with more fidelity
  // and then we can just return the client itself, like we do in redis
  return {
    createCompletion: async (prompt, params = {}) => {
      if (!prompt) {
        throw new Error("Prompt is required");
      };
    
      if (typeof prompt !== "string") {
        throw new Error("Prompt must be a string");
      }
    
      if (!params.model) {
        params.model = "gpt-3.5-turbo";
      };
    
      if (!params.max_tokens) {
        params.max_tokens = 2048;
      }
    
      params.messages = [ { role: 'user', content: prompt } ];
      
      const response = await client.chat.completions.create(params);
      return response.choices[0]?.message?.content;
    }
  };
};
