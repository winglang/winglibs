/// Options for the lift method.
pub struct LiftOptions {
  /// The object to lift.
  obj: std.Resource;

  /// Id of the client. Defaults to the id of the object.
  id: str?;

  /// List of operations to allow for this client
  allow: Array<str>?;
}
