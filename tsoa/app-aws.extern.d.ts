export default interface extern {
  runHandler: (event: Readonly<any>, context: Readonly<any>, clients: Readonly<Record<string, Resource$Inflight>>) => Promise<Readonly<any>>,
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
/** Represents the building block of the construct graph.
All constructs besides the root construct must be created within the scope of
another construct. */
export class Construct$Inflight implements IConstruct$Inflight {
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
/** Shared behavior between all Wing SDK resources. */
export class Resource$Inflight extends Construct$Inflight implements IResource$Inflight {
}