export default interface extern {
  newRedisClient: (url: string, redisPassword: string) => Promise<IRedisClient$Inflight>,
}
export interface IRedis$Inflight {
  readonly del: (key: string) => Promise<void>;
  readonly get: (key: string) => Promise<string | void>;
  readonly hGet: (key: string, field: string) => Promise<string | void>;
  readonly hSet: (key: string, field: string, value: string) => Promise<void>;
  readonly sAdd: (key: string, value: string) => Promise<void>;
  readonly sMembers: (key: string) => Promise<(readonly (string)[]) | void>;
  readonly set: (key: string, value: string) => Promise<void>;
  readonly url: () => Promise<string>;
}
export interface IRedisClient$Inflight extends IRedis$Inflight {
  readonly connect: () => Promise<void>;
  readonly del: (key: string) => Promise<void>;
  readonly disconnect: () => Promise<void>;
  readonly get: (key: string) => Promise<string | void>;
  readonly hGet: (key: string, field: string) => Promise<string | void>;
  readonly hSet: (key: string, field: string, value: string) => Promise<void>;
  readonly sAdd: (key: string, value: string) => Promise<void>;
  readonly sMembers: (key: string) => Promise<(readonly (string)[]) | void>;
  readonly set: (key: string, value: string) => Promise<void>;
  readonly url: () => Promise<string>;
}