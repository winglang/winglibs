bring util;

pub interface IWorkflow {
  onSuccess(cb: inflight (Json?): void): void;
  onError(cb: inflight (Error): void): void;
  
  inflight start(ctx: Json?): void;
  inflight status(): Status;
  inflight ctx(): Json;
  inflight error(): Error?;
  inflight join(opts: util.WaitUntilProps?): Json;

}

pub enum Status {
  NOT_STARTED,
  IN_PROGRESS,
  ERROR,
  DONE
}

pub interface Handler {
  inflight handle(input: Json): Json?;
}

pub interface Predicate {
  inflight handle(input: Json): bool;
}

pub struct Branches {
  ifTrue: Array<Step>;
  ifFalse: Array<Step>?;
}

pub enum StepType {
  EXECUTE,
  CHECK,
}

pub struct Step {
  type: StepType;
  name: str;
}

pub struct CheckStep extends Step {
  predicate: Predicate;
  branches: Branches;
}

pub struct ExecuteStep extends Step {
  handler: Handler;
}

pub struct WorkflowOptions {
  debug: bool?;
}

pub struct Error {
  message: str;
  stack: Array<str>;
}

pub class steps {
  pub static execute(name: str, handler: Handler): Step {
    return ExecuteStep {
      type: StepType.EXECUTE,
      name: name,
      handler: handler,
    };
  }

  pub static check(name: str, predicate: Predicate, branches: Branches): Step {
    return CheckStep {
      type: StepType.CHECK,
      name: name,
      branches: branches,
      predicate: predicate,
    };
  }
}
