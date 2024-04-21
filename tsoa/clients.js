const { AsyncLocalStorage } = require("node:async_hooks");

// this might run in a different context in sim
const asyncLocalStorage = new AsyncLocalStorage();
global.asyncLocalStorage = asyncLocalStorage;

/**
 * Get a Wing client from the request object.
 * @param {string} id - The client Id.
 * @returns {Object} - The requested client.
 */
module.exports.lifted = (id) => {
  const clients = global.asyncLocalStorage.getStore();
  if (!clients || !clients[id]) {
    throw new Error(`Wing client ${id} not found`);
  }
  return clients[id];
};

module.exports.setLifted = (clients) => {
  global.asyncLocalStorage.enterWith(clients);
};
