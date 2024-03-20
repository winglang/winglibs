const openai = require('openai');

exports.createNewInflightClient = (apiKey, org) => {
  const config = { apiKey };

  if (org) {
    config.organization = org;
  }

  let client = new openai.OpenAI(config);

  return {
    createCompletion: async params => {
      return await client.chat.completions.create(params);
    }
  };
};
