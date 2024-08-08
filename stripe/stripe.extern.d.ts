export default interface extern {
  verifyEvent: (options: VerifyEventOptions) => Promise<boolean>,
}
/** Allowed HTTP methods for a endpoint. */
export enum HttpMethod {
  GET = 0,
  HEAD = 1,
  POST = 2,
  PUT = 3,
  DELETE = 4,
  CONNECT = 5,
  OPTIONS = 6,
  PATCH = 7,
}
/** Shape of a request to an inflight handler. */
export interface ApiRequest {
  /** The request's body. */
  readonly body?: (string) | undefined;
  /** The request's headers. */
  readonly headers?: (Readonly<Record<string, string>>) | undefined;
  /** The request's HTTP method. */
  readonly method: HttpMethod;
  /** The request's path. */
  readonly path: string;
  /** The request's query string values. */
  readonly query: Readonly<Record<string, string>>;
  /** The path variables. */
  readonly vars: Readonly<Record<string, string>>;
}
export interface VerifyEventOptions {
  readonly data: ApiRequest;
  readonly secretKey: string;
  readonly webhookSecret: string;
}