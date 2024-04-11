bring cloud;
bring ui;

pub class Sequencer {
  curr: cloud.Counter;
  signal: cloud.Topic;
  handlers: MutArray<inflight (Json?): void>;
  fns: MutArray<cloud.Function>;

  new() {
    this.curr = new cloud.Counter(initial: -1);
    this.handlers = MutArray<inflight (Json?): void>[];
    this.signal = new cloud.Topic();
    this.fns = MutArray<cloud.Function>[];

    this.signal.onMessage(inflight (ctx) => {
      let index = this.curr.inc() + 1;
      if index >= this.handlers.length {
        log("done");
        return;
      }
  
      let curr = this.handlers.at(index);
      curr(Json.tryParse(ctx));
    });

    new ui.Button("Reset", inflight () => {
      this.reset();
    }) as "reset";
    
    new ui.Button("Next", inflight () => {
      this.next();
    }) as "next";

    new ui.Field("Index", inflight () => {
      return "{this.curr.peek()}";
    }) as "index";
  }

  pub push(fn: cloud.Function)  {
    this.handlers.push(inflight (ctx) => {
      fn.invokeAsync(Json.stringify(ctx));
    });

    this.fns.push(fn);
  }

  pub inflight reset() {
    this.curr.set(-1);
  }

  pub inflight next(ctx: Json?) {
    this.signal.publish(Json.stringify(ctx));
  }

  pub inflight index(): num {
    return this.curr.peek();
  }

  pub inflight length(): num {
    return this.handlers.length;
  }

  pub inflight status(): Status {
    let index = this.index();
    if index == -1 {
      return Status.NOT_STARTED;
    } elif index == this.length() - 1 {
      return Status.DONE;
    } else {
      return Status.IN_PROGRESS;
    }
  }
}

pub enum Status {
  NOT_STARTED,
  IN_PROGRESS,
  ERROR,
  DONE
}
