/**
 * A cloud message fanout interface
 */
pub interface IMessageFanout extends std.IResource {
  /**
   * Publish a message to the fanout
   */
  inflight publish(message: str): void;

  /**
   * Create a new consumer for the fanout
   */
  addConsumer(name: str, handler: inflight(str): void): void;
}