import { promisify } from "util";
import jwt from "jsonwebtoken";
import jwksClient from "jwks-rsa";

export const _jwt = () => ({
  sign: promisify(jwt.sign),
  verify: promisify(jwt.verify),
  decode: jwt.decode,
  jwksClient: jwksClient,
});

