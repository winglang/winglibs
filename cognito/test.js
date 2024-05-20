import { createSignedFetcher } from 'aws-sigv4-fetch';

export const sigv4Fetch = {
  createSignedFetcher,
};

export const fetch = async (url, options) => {
  const signedFetch = createSignedFetcher({ service: "execute-api", credentials: {
    accessKeyId: options.AccessKeyId,
    secretAccessKey: options.SecretKey,
    sessionToken: options.SessionToken,
  } });

  const response = await signedFetch(url, {
    method: "get"
  });

  return response.status;
};
