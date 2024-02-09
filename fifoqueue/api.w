bring cloud;

pub struct FifoQueueProps extends cloud.QueueProps{}

pub struct PushOptions {
  groupId: str;
}

pub struct SetConsumerOptions extends cloud.QueueSetConsumerOptions {}

pub interface IFifoQueue {
  setConsumer(handler: inflight (str): void, options: SetConsumerOptions?): void;
  inflight push(message: str, options: PushOptions): void;
}
