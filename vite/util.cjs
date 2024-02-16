const PAYLOAD_PREFIX = "__WINGLIBS_VITE_0WgrTtVXAiskivf2cIM-Z__";

exports.stringifyPayload = (payload) => {
  return `${PAYLOAD_PREFIX}${JSON.stringify(payload)}`;
};

exports.parsePayload = (payload) => {
  if (!payload.startsWith(PAYLOAD_PREFIX)) {
    return undefined;
  }

  return JSON.parse(payload.substring(PAYLOAD_PREFIX.length));
};

const { contentType } = require("mime-types");
const { extname } = require("node:path");
exports.contentType = (filename) => {
  return contentType(extname(filename));
};
