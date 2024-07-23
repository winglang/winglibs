import types from "./cache.extern";
import {
  CacheGet,
  CacheClient,
  Configurations,
  CredentialProvider,
  CacheSet,
} from "@gomomento/sdk";

let cacheClients: Record<string, CacheClient> = {};

async function createCacheClient(token: string) {
  if (!cacheClients[token]) {
    cacheClients[token] = await CacheClient.create({
      configuration: Configurations.Lambda.latest(),
      credentialProvider: CredentialProvider.fromString(token),
      defaultTtlSeconds: 60, // won't be used
    });
  }
}

export const _get: types["_get"] = async (token, cacheName, key) => {
  await createCacheClient(token);
  const getResponse = await cacheClients[token].get(cacheName, key);
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

export const _set: types["_set"] = async (
  token,
  cacheName,
  key,
  value,
  ttl
) => {
  await createCacheClient(token);
  const setResponse = await cacheClients[token].set(cacheName, key, value, {
    ttl,
  });
  if (setResponse instanceof CacheSet.Success) {
    return;
  } else if (setResponse instanceof CacheSet.Error) {
    throw setResponse.innerException();
  } else {
    throw new Error("Unexpected response type");
  }
};
