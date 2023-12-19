bring util;
bring "./api.w" as api;
bring "./fifo-queue.sim.w" as sim;
bring "./fifo-queue.aws.w" as aws;

pub class FifoQueue impl api.IFifoQueue {
  inner: api.IFifoQueue;
  new(props: api.FifoQueueProps?) {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      this.inner = new sim.FifoQueue_sim() as "sim";
    } elif target == "tf-aws" {
      this.inner = new aws.FifoQueue_aws(props) as "tf-aws";
    } else {
      throw "Unsupported target {target}";
    }
  }

  pub setConsumer(fn: inflight (str): void, options: api.SetConsumerOptions?) {
    this.inner.setConsumer(fn, options);

  }

  pub inflight push(message: str, options: api.PushOptions) {
    this.inner.push(message, options);
  }
}