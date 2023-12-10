bring expect;
bring util;
bring cloud;
bring "./api.w" as api;

struct FifoQueueMessage  {
  groupId: str;
  message: str;
}

pub class FifoQueue_sim impl api.IFifoQueue { 
  queue: cloud.Queue;
  counter: cloud.Counter;
  
  new(){
    this.queue = new cloud.Queue();
    this.counter = new cloud.Counter();
  }

  pub setConsumer(fn: inflight (str): void, options: api.SetConsumerOptions?) {
    let counter = this.counter;
    this.queue.setConsumer(inflight (m: str) => {
      let j = FifoQueueMessage.parseJson(m);
      util.waitUntil(inflight () => {
        let value = counter.peek(j.groupId);
        if value == 0 {
          let acquired = counter.inc(1, j.groupId);
          if acquired == 0 {
            return true;
          } else {
            counter.dec(1, j.groupId);
            return false;
          }
        }
        return false;
      }, timeout: 30m);

      fn(j.message);
      counter.dec(1, j.groupId);
    });

  }

  inflight pub push(message: str, options: api.PushOptions) {
    this.queue.push(Json.stringify({ groupId: options.groupId, message: message }));
  }
}
