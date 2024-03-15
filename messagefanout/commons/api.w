bring cloud;

pub struct MessageFanoutProps extends cloud.QueueProps {
  name: str;
}

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
  addConsumer(handler: inflight(str): void, props: MessageFanoutProps): void;
}
