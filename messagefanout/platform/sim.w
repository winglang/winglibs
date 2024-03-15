bring cloud;
bring "../commons/api.w" as api;

pub class MessageFanout_sim impl api.IMessageFanout {
  topic: cloud.Topic;
  queueList: MutArray<cloud.Queue>;

  new() {
    this.topic = new cloud.Topic();
    this.queueList = MutArray<cloud.Queue>[];
  }

  pub addConsumer(handler: inflight(str): void, props: api.MessageFanoutProps): void {
    let queue = new cloud.Queue(
      // timeout: props.timeout ?? duration.fromSeconds(120),
      retentionPeriod: props.retentionPeriod ?? duration.fromHours(1)
    ) as "queue_" + props.name;

    queue.setConsumer(handler);

    this.topic.onMessage(inflight (msg: str) => {
      queue.push(msg);
    });

    this.queueList.push(queue);
  }

  pub inflight publish(message: str) {
    this.topic.publish(message);
  }
}