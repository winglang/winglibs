import types from "./cache.extern";
import {
  CacheGet,
  CacheClient,
  Configurations,
  CredentialProvider,
  CacheSet,
} from "@gomomento/sdk";

let cacheClient: CacheClient;

async function createCacheClient() {
  if (!cacheClient) {
    cacheClient = await CacheClient.create({
      configuration: Configurations.Lambda.latest(),
      credentialProvider: CredentialProvider.fromEnvironmentVariable({
        environmentVariableName: "MOMENTO_AUTH_TOKEN",
      }),
      defaultTtlSeconds: 60, // won't be used
    });
  }
}

export const _get: types["_get"] = async (cacheName, key) => {
  await createCacheClient();
  const getResponse = await cacheClient.get(cacheName, key);
  if (getResponse instanceof CacheGet.Hit) {
    return getResponse.valueString();
  } else if (getResponse instanceof CacheGet.Miss) {
    return undefined;
  } else if (getResponse instanceof CacheGet.Error) {
    throw getResponse.innerException();
  } else {
    throw new Error("Unexpected response type");
  }
};

export const _set: types["_set"] = async (cacheName, key, value, ttl) => {
  await createCacheClient();
  const setResponse = await cacheClient.set(cacheName, key, value, { ttl });
  if (setResponse instanceof CacheSet.Success) {
    return;
  } else if (setResponse instanceof CacheSet.Error) {
    throw setResponse.innerException();
  } else {
    throw new Error("Unexpected response type");
  }
};
