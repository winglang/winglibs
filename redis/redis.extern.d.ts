export default interface extern {
  newRedisClient: (url: string, redisPassword: string) => Promise<IRedisClient$Inflight>,
}
/** Trait marker for classes that can be depended upon.
The presence of this interface indicates that an object has
an `IDependable` implementation.

This interface can be used to take an (ordering) dependency on a set of
constructs. An ordering dependency implies that the resources represented by
those constructs are deployed before the resources depending ON them are
deployed. */
export interface IDependable$Inflight {
}
/** Represents a construct. */
export interface IConstruct$Inflight extends IDependable$Inflight {
}
/** Data that can be lifted into inflight. */
export interface ILiftable$Inflight {
}
/** A liftable object that needs to be registered on the host as part of the lifting process.
This is generally used so the host can set up permissions
to access the lifted object inflight. */
export interface IHostedLiftable$Inflight extends ILiftable$Inflight {
}
/** Abstract interface for `Resource`. */
export interface IResource$Inflight extends IConstruct$Inflight, IHostedLiftable$Inflight {
}
export interface IRedis$Inflight extends IResource$Inflight {
  readonly del: (key: string) => Promise<void>;
  readonly get: (key: string) => Promise<(string) | undefined>;
  readonly hGet: (key: string, field: string) => Promise<(string) | undefined>;
  readonly hSet: (key: string, field: string, value: string) => Promise<void>;
  readonly sAdd: (key: string, value: string) => Promise<void>;
  readonly sMembers: (key: string) => Promise<((readonly (string)[])) | undefined>;
  readonly set: (key: string, value: string) => Promise<void>;
  readonly url: () => Promise<string>;
}
export interface IRedisClient$Inflight extends IRedis$Inflight {
  readonly connect: () => Promise<void>;
  readonly del: (key: string) => Promise<void>;
  readonly disconnect: () => Promise<void>;
  readonly get: (key: string) => Promise<(string) | undefined>;
  readonly hGet: (key: string, field: string) => Promise<(string) | undefined>;
  readonly hSet: (key: string, field: string, value: string) => Promise<void>;
  readonly sAdd: (key: string, value: string) => Promise<void>;
  readonly sMembers: (key: string) => Promise<((readonly (string)[])) | undefined>;
  readonly set: (key: string, value: string) => Promise<void>;
  readonly url: () => Promise<string>;
}