module.exports.getClients = (req) => {
  return req.__wing_clients;
};

/**
 * Get a Wing client from the request object.
 * @param {Object} req - The request object.
 * @param {string} id - The client Id.
 * @returns {Object} - The requested client.
 */
module.exports.getClient = (req, id) => {
  if (!req.__wing_clients || !req.__wing_clients[id]) {
    throw new Error(`Wing client ${id} not found`);
  }
  return req.__wing_clients[id];
};

module.exports.setClients = (req, clients) => {
  req.__wing_clients = clients;
};
