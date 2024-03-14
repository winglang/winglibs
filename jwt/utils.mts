import jwt, { VerifyOptions } from "jsonwebtoken";
import jwksClient from "jwks-rsa";

export const _sign = jwt.sign;

export const _verifyWithSecret = jwt.verify;

export const _verifyWithJwksUri = async (token: string, uri: string, options?: VerifyOptions) => {
  const client = jwksClient({
    jwksUri: uri
  });
  function getKey(header, callback){
    client.getSigningKey(header.kid, function(err, key) {
      if (err) {
        callback(err);
      }
      
      var signingKey = key?.getPublicKey();
      callback(null, signingKey);
    });
  }
  return new Promise((resolve, reject) => {
    jwt.verify(token, getKey, options, function(err, decoded) {
      if (err) {
        reject(err);
      } else {
        resolve(decoded);
      }
    });
  });
};
