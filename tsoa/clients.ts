import { AsyncLocalStorage } from "node:async_hooks";

const asyncLocalStorage = new AsyncLocalStorage();

/**
 * Get a Wing client from the request object.
 * @param {string} id - The client Id.
 * @returns {T} - The requested client.
 */
export function lifted<T>(id: string): T {
  const clients: any = asyncLocalStorage.getStore();
  if (!clients || !clients[id]) {
    throw new Error(`Wing client "${id}" not found`);
  }
  return clients[id];
};

export function setLifted(clients: any) {
  asyncLocalStorage.enterWith(clients);
};
