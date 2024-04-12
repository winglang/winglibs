bring cloud;
bring ui;
bring util;
bring "./seq.w" as seq;
bring "./state.w" as state;
bring "../../api.w" as api;
bring "../util" as u;

pub class Workflow impl api.IWorkflow {
  steps: Array<api.Step>;
  sequencer: seq.Sequencer;
  store: state.State;

  successCallbacks: MutArray<inflight (Json?): void>;
  errorCallbacks: MutArray<inflight (api.Error): void>;

  new(steps: Array<api.Step>, opts: api.WorkflowOptions?) {
    let debug = opts?.debug ?? false;

    this.steps = steps;
    this.successCallbacks = MutArray<inflight (Json?): void>[];
    this.errorCallbacks = MutArray<inflight (api.Error): void>[];

    this.sequencer = new seq.Sequencer();
    this.store = new state.State();

    if !debug {
      nodeof(this.sequencer).hidden = true;
      nodeof(this.store).hidden = true;
    }

    let var prev: Array<std.IResource> = [];
    for step in steps {
      if step.type == api.StepType.EXECUTE { 
        prev = this.addExecuteStep(prev, unsafeCast(step));
      } elif step.type == api.StepType.CHECK {
        prev = this.addCheckStep(prev, unsafeCast(step));
      } else {
        throw "unknown type {step.type}";
      }
    }

    new ui.Button("Start", inflight () => { this.start({}); }) as "start_button";
    new ui.Field("Context", inflight () => { return Json.stringify(this.ctx()); }) as "context_field";
    new ui.Field("Error", inflight () => { return Json.stringify(this.error()); }) as "error_field";

    // last step is the on-success handler
    this.addSuccessHandler();
  }

  // -- preflight api

  pub onSuccess(cb: inflight (Json?): void) {
    this.successCallbacks.push(cb);
  }

  pub onError(cb: inflight (api.Error): void) {
    this.errorCallbacks.push(cb);
  }

  // -- inflight api

  pub inflight start(ctx: Json?) {
    this.sequencer.reset();
    this.sequencer.next(ctx);
  }

  pub inflight status(): api.Status {
    if this.store.getError() != nil {
      return api.Status.DONE;
    }

    return this.sequencer.status();
  }

  pub inflight ctx(): Json {
    return this.store.get();
  }

  pub inflight error(): api.Error? {
    return api.Error.tryFromJson(this.store.getError());
  }

  /** waits until the workflow finishes execution */
  pub inflight join(opts: util.WaitUntilProps?): Json {
    util.waitUntil(
      inflight () => { 
        if let err = this.error() {
          throw err.message;
        }

        return this.status() == api.Status.DONE;
      },
      opts
    );

    return this.ctx();
  }

  // -- private

  addExecuteStep(prev: Array<std.IResource>, step: api.ExecuteStep, opts: api.WorkflowOptions): Array<std.Resource> {
    let handler = new cloud.Function(inflight (ctx) => {
      let inp = Json.tryParse(ctx) ?? {};
      let var output = inp;
      try {
        output = step.handler.handle(inp) ?? {};
      } catch err {
        this.fail(message: err, stack: []);
        return nil;
      }

      let merged = u.mergeJson(inp, output);
      log("{step.name} => {Json.stringify(merged, indent: 2)}");
      this.store.set(merged);
      this.sequencer.next(merged);
    }) as step.name;

    nodeof(handler).title = step.name;
    nodeof(handler).color = "violet";

    for p in prev {
      nodeof(p).addConnection(source: p, target: handler, name: "next");
    }

    this.sequencer.push(handler);

    return [handler];
  }

  addCheckStep(prev: Array<std.IResource>, step: api.CheckStep, opts: api.WorkflowOptions): Array<std.IResource> {
    let checkStep: api.CheckStep = unsafeCast(step);
    let sequencer = this.sequencer;
    let trueWorkflow = new Workflow(checkStep.branches.ifTrue, opts) as "{step.name} - then";
    let falseWorkflow = new Workflow(checkStep.branches.ifFalse ?? [], opts) as "{step.name} - else";
    trueWorkflow.onSuccess(inflight (ctx) => { sequencer.next(ctx); });
    trueWorkflow.onError(inflight (err) => { this.fail(err); });
    falseWorkflow.onSuccess(inflight (ctx) => { sequencer.next(ctx); });
    falseWorkflow.onError(inflight (err) => { this.fail(err); });

    class Predicate {}
    let pred = new Predicate();

    let handler = new cloud.Function(inflight (ctx) => {
      let inp = Json.tryParse(ctx) ?? {};
      let result = checkStep.predicate.handle(inp);
      log("check {step.name} => {result}");
      if result {
        trueWorkflow.start(inp);
      } else {
        falseWorkflow.start(inp);
      }
    }) as step.name in pred;
    
    nodeof(pred).title = step.name;
    nodeof(pred).color = "purple";
    nodeof(pred).addConnection(source: pred, target: trueWorkflow, name: "then");
    nodeof(pred).addConnection(source: pred, target: falseWorkflow, name: "else");

    for p in prev {
      nodeof(p).addConnection(source: p, target: handler, name: "next");
    }

    sequencer.push(handler);
    return [trueWorkflow, falseWorkflow];
  }

  addSuccessHandler() {
    let handler = new cloud.Function(inflight (ctx) => {
      let inp = Json.tryParse(ctx);
      for cb in this.successCallbacks {
        cb(inp);
      }
    }) as "on_success";

    nodeof(handler).title = "on_success";
    nodeof(handler).hidden = true;

    this.sequencer.push(handler);
  }

  inflight fail(err: api.Error) {
    this.store.setError(err);
    for cb in this.errorCallbacks {
      cb(err);
    }
  }
}
