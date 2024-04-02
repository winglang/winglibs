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

pub struct DecodeOptions {
  complete: bool?;
}

pub struct SignOptions {
  algorithm: str?;
  keyid: str?;
  expiresIn: duration?;
  notBefore: duration?;
  audience: Array<str>?;
  subject: str?;
  issuer: str?;
  jwtid: str?;
  encoding: str?;
}

struct JwtHeader {
  alg: str?;
  typ: str?;
  cty: str?;
  crit: Array<str>?;
  kid: str?;
  jku: str?;
  x5u: str?;
  x5t: str?;
  x5c: str?;
}

struct IJwksClientOptions {
  jwksUri: str;
}

interface IJwksSigningKey {
  inflight getPublicKey(): str;
}

interface IJwksClient {
  inflight getSigningKey(kid: str?): IJwksSigningKey;
}

interface IJwt {
  inflight jwksClient(options: IJwksClientOptions): IJwksClient;
  inflight sign(data: Json, secret: str, options: Json?): str;
  inflight verify(token: str, secret: inflight (JwtHeader, inflight (str, str): void): void, options: VerifyJwtOptions?): Json;
  inflight decode(token: str, options: DecodeOptions?): Json;
}

class JwtUtil {
  extern "./utils.js" pub static inflight _jwt(): IJwt;
}

pub class Util {
  pub inflight static sign(data: Json, secret: str, options: SignOptions?): str {
    let var opts: MutJson? = nil;
    if let options = options {
      opts = MutJson Json.parse(Json.stringify(options));
      if let expiresIn = options.expiresIn {
        opts?.set("expiresIn", expiresIn.seconds);
      }
      if let notBefore = options.notBefore {
        opts?.set("notBefore", notBefore.seconds);
      }
    }
    return JwtUtil._jwt().sign(data, secret, opts);
  }

  pub inflight static verify(token: str, options: VerifyOptions): Json {
    if let secret = options.secret {
      let getKey = inflight (header: JwtHeader, callback: inflight (str, str): void) => {
        callback(unsafeCast(nil), secret);
      };
      let decoded = JwtUtil._jwt().verify(token, getKey, options.options);
      return decoded;
    } elif let jwksUri = options.jwksUri {
      let client = JwtUtil._jwt().jwksClient(jwksUri: jwksUri);
      let getKey = inflight (header: JwtHeader, callback: inflight (str, str): void) => {
        try {
          let secret = client.getSigningKey(header.kid).getPublicKey();
          callback(unsafeCast(nil), secret);
        } catch error {
          callback(error, unsafeCast(nil));
        }
      };
      let decoded = JwtUtil._jwt().verify(token, getKey, options.options);
      return decoded;
    } else {
      throw "Either secret or jwksUri must be provided";
    }
  }
  
  pub inflight static decode(token: str, options: DecodeOptions?): Json {
    return JwtUtil._jwt().decode(token, options);
  }
}
