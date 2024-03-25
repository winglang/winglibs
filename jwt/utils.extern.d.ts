export default interface extern {
  _jwt: () => Promise<IJwt$Inflight>,
}
export interface IJwksClientOptions {
  readonly jwksUri: string;
}
export interface IJwksSigningKey$Inflight {
  readonly getPublicKey: () => Promise<string>;
}
export interface IJwksClient$Inflight {
  readonly getSigningKey: (kid?: (string) | undefined) => Promise<IJwksSigningKey$Inflight>;
}
export interface SignOptions {
  readonly algorithm?: (string) | undefined;
  readonly audience?: ((readonly (string)[])) | undefined;
  readonly encoding?: (string) | undefined;
  readonly expiresIn?: (number) | undefined;
  readonly issuer?: (string) | undefined;
  readonly jwtid?: (string) | undefined;
  readonly keyid?: (string) | undefined;
  readonly notBefore?: (number) | undefined;
  readonly subject?: (string) | undefined;
}
export interface JwtHeader {
  readonly alg?: (string) | undefined;
  readonly crit?: ((readonly (string)[])) | undefined;
  readonly cty?: (string) | undefined;
  readonly jku?: (string) | undefined;
  readonly kid?: (string) | undefined;
  readonly typ?: (string) | undefined;
  readonly x5c?: (string) | undefined;
  readonly x5t?: (string) | undefined;
  readonly x5u?: (string) | undefined;
}
export interface VerifyJwtOptions {
  readonly algorithms?: ((readonly (string)[])) | undefined;
  readonly audience?: (string) | undefined;
  readonly ignoreExpiration?: (boolean) | undefined;
  readonly ignoreNotBefore?: (boolean) | undefined;
  readonly issuer?: (string) | undefined;
  readonly jwtid?: (string) | undefined;
  readonly maxAge?: (string) | undefined;
  readonly nonce?: (string) | undefined;
  readonly subject?: (string) | undefined;
}
export interface IJwt$Inflight {
  readonly jwksClient: (options: IJwksClientOptions) => Promise<IJwksClient$Inflight>;
  readonly sign: (data: Readonly<any>, secret: string, options?: (SignOptions) | undefined) => Promise<string>;
  readonly verify: (token: string, secret: (arg0: JwtHeader, arg1: (arg0: string, arg1: string) => Promise<void>) => Promise<void>, options?: (VerifyJwtOptions) | undefined) => Promise<Readonly<any>>;
}