export default interface extern {
  build: (options: StartServiceOptions) => BuildServiceResult,
  dirname: () => string,
  startService: (options: StartServiceOptions) => Promise<StartResponse$Inflight>,
}
/** Trait marker for classes that can be depended upon.
The presence of this interface indicates that an object has
an `IDependable` implementation.

This interface can be used to take an (ordering) dependency on a set of
constructs. An ordering dependency implies that the resources represented by
those constructs are deployed before the resources depending ON them are
deployed. */
export interface IDependable {
}
/** Represents a construct. */
export interface IConstruct extends IDependable {
}
/** Represents the building block of the construct graph.
All constructs besides the root construct must be created within the scope of
another construct. */
export class Construct implements IConstruct {
  /** Returns a string representation of this construct. */
  readonly toString: () => string;
}
/** Data that can be lifted into inflight. */
export interface ILiftable {
}
/** A resource that can run inflight code. */
export interface IInflightHost extends IResource {
  /** Adds an environment variable to the host. */
  readonly addEnvironment: (name: string, value: string) => void;
}
/** A liftable object that needs to be registered on the host as part of the lifting process.
This is generally used so the host can set up permissions
to access the lifted object inflight. */
export interface IHostedLiftable extends ILiftable {
  /** A hook called by the Wing compiler once for each inflight host that needs to use this object inflight.
  The list of requested inflight methods
  needed by the inflight host are given by `ops`.
  
  Any preflight class can implement this instance method to add permissions,
  environment variables, or other capabilities to the inflight host when
  one or more of its methods are called. */
  readonly onLift: (host: IInflightHost, ops: (readonly (string)[])) => void;
}
/** Abstract interface for `Resource`. */
export interface IResource extends IConstruct, IHostedLiftable {
  /** A hook called by the Wing compiler once for each inflight host that needs to use this object inflight.
  The list of requested inflight methods
  needed by the inflight host are given by `ops`.
  
  Any preflight class can implement this instance method to add permissions,
  environment variables, or other capabilities to the inflight host when
  one or more of its methods are called. */
  readonly onLift: (host: IInflightHost, ops: (readonly (string)[])) => void;
}
/** Shared behavior between all Wing SDK resources. */
export class Resource extends Construct implements IResource {
  /** A hook called by the Wing compiler once for each inflight host that needs to use this resource inflight.
  You can override this method to perform additional logic like granting
  IAM permissions to the host based on what methods are being called. But
  you must call `super.bind(host, ops)` to ensure that the resource is
  actually bound. */
  readonly onLift: (host: IInflightHost, ops: (readonly (string)[])) => void;
}
export interface SpecProps {
  readonly outputDirectory?: (string) | undefined;
  readonly specVersion?: (number) | undefined;
}
export interface ServiceProps {
  readonly controllerPathGlobs: (readonly (string)[]);
  readonly entryFile?: (string) | undefined;
  readonly outputDirectory: string;
  readonly routesDir: string;
  readonly spec?: (SpecProps) | undefined;
  readonly watchDir?: (string) | undefined;
}
export interface StartServiceOptions {
  readonly basedir: string;
  readonly clients: Readonly<Record<string, Resource>>;
  readonly currentdir: string;
  readonly homeEnv: string;
  readonly lastPort?: (string) | undefined;
  readonly options: ServiceProps;
  readonly pathEnv: string;
  readonly workdir: string;
}
export interface BuildServiceResult {
  readonly routesFile: string;
  readonly specFile: string;
}
export interface StartResponse$Inflight {
  readonly close: () => Promise<void>;
  readonly port: () => Promise<number>;
  readonly specFile: () => Promise<string>;
}