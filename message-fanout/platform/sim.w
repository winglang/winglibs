bring cloud;
bring "../commons/api.w" as api;

pub class MessageFanout_sim impl api.IMessageFanout {
  topic: cloud.Topic;

  new() {
    this.topic = new cloud.Topic();
  }

  pub addConsumer(handler: inflight(str): void, props: api.MessageFanoutProps): void {}
  pub inflight publish(message: str) {}
}