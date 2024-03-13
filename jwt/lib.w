pub struct VerifyJwtOptions {
  algorithms: Array<str>?;
  audience: str?;
  issuer: str?;
  ignoreExpiration: bool?;
  ignoreNotBefore: bool?;
  jwtid: str?;
  nonce: str?;
  subject: str?;
  maxAge: str?;
}

pub struct VerifyOptions  {
  secret: str?;
  jwksUri: str?;
  options: VerifyJwtOptions?;
}

pub struct SignOptions {
  algorithm: str?;
  keyid: str?;
  // expressed in seconds
  expiresIn: num?;
  // expressed in seconds
  notBefore: num?;
  audience: Array<str>?;
  subject: str?;
  issuer: str?;
  jwtid: str?;
  encoding: str?;
}

class HiddenUtil {
  extern "./utils.mts" pub static inflight _sign(data: Json, secret: str, options: SignOptions?): str;
  extern "./utils.mts" pub static inflight _verifyWithSecret(token: str, secret: str, options: VerifyJwtOptions?): Json;
  extern "./utils.mts" pub static inflight _verifyWithJwksUri(token: str, uri: str, options: VerifyJwtOptions?): Json;
}

pub class Util {
  pub inflight static sign(data: Json, secret: str, options: SignOptions?): str {
    return HiddenUtil._sign(data, secret, options);
  }

  pub inflight static verify(token: str, options: VerifyOptions): Json {
    if let secret = options.secret {
      let decoded = HiddenUtil._verifyWithSecret(token, secret, options.options);
      return decoded;
    } elif let jwksUri = options.jwksUri {
      let decoded = HiddenUtil._verifyWithJwksUri(token, jwksUri, options.options);
      return decoded;
    } else {
      throw "Either secret or jwksUri must be provided";
    }
  }
}
