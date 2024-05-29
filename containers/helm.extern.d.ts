export default interface extern {
  toHelmChart: (wingdir: string, chart: Chart) => string,
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
/** Options for `construct.addMetadata()`. */
export interface MetadataOptions {
  /** Include stack trace with metadata entry. */
  readonly stackTrace?: (boolean) | undefined;
  /** A JavaScript function to begin tracing from.
  This option is ignored unless `stackTrace` is `true`. */
  readonly traceFromFunction?: (any) | undefined;
}
/** Implement this interface in order for the construct to be able to validate itself. */
export interface IValidation {
  /** Validate the current construct.
  This method can be implemented by derived constructs in order to perform
  validation logic. It is called on all constructs before synthesis.
  @returns An array of validation error messages, or an empty array if there the construct is valid. */
  readonly validate: () => (readonly (string)[]);
}
/** In what order to return constructs. */
export enum ConstructOrder {
  PREORDER = 0,
  POSTORDER = 1,
}
/** An entry in the construct metadata table. */
export interface MetadataEntry {
  /** The data. */
  readonly data?: any;
  /** Stack trace at the point of adding the metadata.
  Only available if `addMetadata()` is called with `stackTrace: true`. */
  readonly trace?: ((readonly (string)[])) | undefined;
  /** The metadata entry type. */
  readonly type: string;
}
/** Represents the construct node in the scope tree. */
export class Node {
  /** Add an ordering dependency on another construct.
  An `IDependable` */
  readonly addDependency: (deps: (readonly (IDependable)[])) => void;
  /** Adds a metadata entry to this construct.
  Entries are arbitrary values and will also include a stack trace to allow tracing back to
  the code location for when the entry was added. It can be used, for example, to include source
  mapping in CloudFormation templates to improve diagnostics. */
  readonly addMetadata: (type: string, data?: any, options?: (MetadataOptions) | undefined) => void;
  /** Adds a validation to this construct.
  When `node.validate()` is called, the `validate()` method will be called on
  all validations and all errors will be returned. */
  readonly addValidation: (validation: IValidation) => void;
  /** Returns an opaque tree-unique address for this construct.
  Addresses are 42 characters hexadecimal strings. They begin with "c8"
  followed by 40 lowercase hexadecimal characters (0-9a-f).
  
  Addresses are calculated using a SHA-1 of the components of the construct
  path.
  
  To enable refactorings of construct trees, constructs with the ID `Default`
  will be excluded from the calculation. In those cases constructs in the
  same tree may have the same addreess.
  c83a2846e506bcc5f10682b564084bca2d275709ee */
  readonly addr: string;
  /** All direct children of this construct. */
  readonly children: (readonly (IConstruct)[]);
  /** Returns the child construct that has the id `Default` or `Resource"`.
  This is usually the construct that provides the bulk of the underlying functionality.
  Useful for modifications of the underlying construct that are not available at the higher levels.
  Override the defaultChild property.
  
  This should only be used in the cases where the correct
  default child is not named 'Resource' or 'Default' as it
  should be.
  
  If you set this to undefined, the default behavior of finding
  the child named 'Resource' or 'Default' will be used.
  @returns a construct or undefined if there is no default child */
  defaultChild?: (IConstruct) | undefined;
  /** Return all dependencies registered on this node (non-recursive). */
  readonly dependencies: (readonly (IConstruct)[]);
  /** Return this construct and all of its children in the given order. */
  readonly findAll: (order?: (ConstructOrder) | undefined) => (readonly (IConstruct)[]);
  /** Return a direct child by id.
  Throws an error if the child is not found.
  @returns Child with the given id. */
  readonly findChild: (id: string) => IConstruct;
  /** Retrieves the all context of a node from tree context.
  Context is usually initialized at the root, but can be overridden at any point in the tree.
  @returns The context object or an empty object if there is discovered context */
  readonly getAllContext: (defaults?: (Readonly<any>) | undefined) => any;
  /** Retrieves a value from tree context if present. Otherwise, would throw an error.
  Context is usually initialized at the root, but can be overridden at any point in the tree.
  @returns The context value or throws error if there is no context value for this key */
  readonly getContext: (key: string) => any;
  /** The id of this construct within the current scope.
  This is a scope-unique id. To obtain an app-unique id for this construct, use `addr`. */
  readonly id: string;
  /** Locks this construct from allowing more children to be added.
  After this
  call, no more children can be added to this construct or to any children. */
  readonly lock: () => void;
  /** Returns true if this construct or the scopes in which it is defined are locked. */
  readonly locked: boolean;
  /** An immutable array of metadata objects associated with this construct.
  This can be used, for example, to implement support for deprecation notices, source mapping, etc. */
  readonly metadata: (readonly (MetadataEntry)[]);
  /** The full, absolute path of this construct in the tree.
  Components are separated by '/'. */
  readonly path: string;
  /** Returns the root of the construct tree.
  @returns The root of the construct tree. */
  readonly root: IConstruct;
  /** Returns the scope in which this construct is defined.
  The value is `undefined` at the root of the construct scope tree. */
  readonly scope?: (IConstruct) | undefined;
  /** All parent scopes of this construct.
  @returns a list of parent scopes. The last element in the list will always
  be the current construct and the first element will be the root of the
  tree. */
  readonly scopes: (readonly (IConstruct)[]);
  /** This can be used to set contextual values.
  Context must be set before any children are added, since children may consult context info during construction.
  If the key already exists, it will be overridden. */
  readonly setContext: (key: string, value?: any) => void;
  /** Return a direct child by id, or undefined.
  @returns the child if found, or undefined */
  readonly tryFindChild: (id: string) => (IConstruct) | undefined;
  /** Retrieves a value from tree context.
  Context is usually initialized at the root, but can be overridden at any point in the tree.
  @returns The context value or `undefined` if there is no context value for this key. */
  readonly tryGetContext: (key: string) => any;
  /** Remove the child with the given name, if present.
  @returns Whether a child with the given name was deleted. */
  readonly tryRemoveChild: (childName: string) => boolean;
  /** Validates this construct.
  Invokes the `validate()` method on all validations added through
  `addValidation()`.
  @returns an array of validation error messages associated with this
  construct. */
  readonly validate: () => (readonly (string)[]);
}
/** Represents a construct. */
export interface IConstruct extends IDependable {
  /** The tree node. */
  readonly node: Node;
}
/** Represents the building block of the construct graph.
All constructs besides the root construct must be created within the scope of
another construct. */
export class Construct implements IConstruct {
  /** The tree node. */
  readonly node: Node;
  /** Returns a string representation of this construct. */
  readonly toString: () => string;
}
/** Utility for applying RFC-6902 JSON-Patch to a document.
Use the the `JsonPatch.apply(doc, ...ops)` function to apply a set of
operations to a JSON document and return the result.

Operations can be created using the factory methods `JsonPatch.add()`,
`JsonPatch.remove()`, etc.
const output = JsonPatch.apply(input,
 JsonPatch.replace('/world/hi/there', 'goodbye'),
 JsonPatch.add('/world/foo/', 'boom'),
 JsonPatch.remove('/hello')); */
export class JsonPatch {
}
/** OwnerReference contains enough information to let you identify an owning object.
An owning object must be in the same namespace as the dependent, or
be cluster-scoped, so there is no namespace field. */
export interface OwnerReference {
  /** API version of the referent. */
  readonly apiVersion: string;
  /** If true, AND if the owner has the "foregroundDeletion" finalizer, then the owner cannot be deleted from the key-value store until this reference is removed.
  Defaults to false. To set this field, a user needs "delete"
  permission of the owner, otherwise 422 (Unprocessable Entity) will be
  returned. */
  readonly blockOwnerDeletion?: (boolean) | undefined;
  /** If true, this reference points to the managing controller. */
  readonly controller?: (boolean) | undefined;
  /** Kind of the referent.
  @see https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds */
  readonly kind: string;
  /** Name of the referent.
  @see http://kubernetes.io/docs/user-guide/identifiers#names */
  readonly name: string;
  /** UID of the referent.
  @see http://kubernetes.io/docs/user-guide/identifiers#uids */
  readonly uid: string;
}
/** Object metadata. */
export class ApiObjectMetadataDefinition {
  /** Adds an arbitrary key/value to the object metadata. */
  readonly add: (key: string, value?: any) => void;
  /** Add an annotation. */
  readonly addAnnotation: (key: string, value: string) => void;
  /** Add one or more finalizers. */
  readonly addFinalizers: (finalizers: (readonly (string)[])) => void;
  /** Add a label. */
  readonly addLabel: (key: string, value: string) => void;
  /** Add an owner. */
  readonly addOwnerReference: (owner: OwnerReference) => void;
  /** 
  @returns a value of a label or undefined */
  readonly getLabel: (key: string) => (string) | undefined;
  /** The name of the API object.
  If a name is specified in `metadata.name` this will be the name returned.
  Otherwise, a name will be generated by calling
  `Chart.of(this).generatedObjectName(this)`, which by default uses the
  construct path to generate a DNS-compatible name for the resource. */
  readonly name?: (string) | undefined;
  /** The object's namespace. */
  readonly namespace?: (string) | undefined;
  /** Synthesizes a k8s ObjectMeta for this metadata set. */
  readonly toJson: () => any;
}
export class ApiObject extends Construct {
  /** Create a dependency between this ApiObject and other constructs.
  These can be other ApiObjects, Charts, or custom. */
  readonly addDependency: (dependencies: (readonly (IConstruct)[])) => void;
  /** Applies a set of RFC-6902 JSON-Patch operations to the manifest synthesized for this API object.
    kubePod.addJsonPatch(JsonPatch.replace('/spec/enableServiceLinks', true)); */
  readonly addJsonPatch: (ops: (readonly (JsonPatch)[])) => void;
  /** The group portion of the API version (e.g. `authorization.k8s.io`). */
  readonly apiGroup: string;
  /** The object's API version (e.g. `authorization.k8s.io/v1`). */
  readonly apiVersion: string;
  /** The chart in which this object is defined. */
  readonly chart: Chart;
  /** The object kind. */
  readonly kind: string;
  /** Metadata associated with this API object. */
  readonly metadata: ApiObjectMetadataDefinition;
  /** The name of the API object.
  If a name is specified in `metadata.name` this will be the name returned.
  Otherwise, a name will be generated by calling
  `Chart.of(this).generatedObjectName(this)`, which by default uses the
  construct path to generate a DNS-compatible name for the resource. */
  readonly name: string;
  /** Renders the object to Kubernetes JSON.
  To disable sorting of dictionary keys in output object set the
  `CDK8S_DISABLE_SORT` environment variable to any non-empty value. */
  readonly toJson: () => any;
}
export class Chart extends Construct {
  /** Create a dependency between this Chart and other constructs.
  These can be other ApiObjects, Charts, or custom. */
  readonly addDependency: (dependencies: (readonly (IConstruct)[])) => void;
  /** Returns all the included API objects. */
  readonly apiObjects: (readonly (ApiObject)[]);
  /** Generates a app-unique name for an object given it's construct node path.
  Different resource types may have different constraints on names
  (`metadata.name`). The previous version of the name generator was
  compatible with DNS_SUBDOMAIN but not with DNS_LABEL.
  
  For example, `Deployment` names must comply with DNS_SUBDOMAIN while
  `Service` names must comply with DNS_LABEL.
  
  Since there is no formal specification for this, the default name
  generation scheme for kubernetes objects in cdk8s was changed to DNS_LABEL,
  since it’s the common denominator for all kubernetes resources
  (supposedly).
  
  You can override this method if you wish to customize object names at the
  chart level. */
  readonly generateObjectName: (apiObject: ApiObject) => string;
  /** Labels applied to all resources in this chart.
  This is an immutable copy. */
  readonly labels: Readonly<Record<string, string>>;
  /** The default namespace for all objects in this chart. */
  readonly namespace?: (string) | undefined;
  /** Renders this chart to a set of Kubernetes JSON resources.
  @returns array of resource manifests */
  readonly toJson: () => (readonly (any)[]);
}