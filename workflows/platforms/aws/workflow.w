bring util;
bring aws;
bring cloud;
bring "../../api.w" as api;
bring "./tf.w" as tf;
bring "../util" as u;

pub class Workflow impl api.IWorkflow {
  new(steps: Array<api.Step>) {

    let asl = this.renderASL(steps);

    let role = new tf.TerraformResource({
      type: "aws_iam_role",
      attributes: {
        inline_policy: {
          name: "lambda-invoke",
          policy: Json.stringify({
            Version: "2012-10-17",
            Statement: [ 
              { Effect: "Allow", Action: [ "lambda:InvokeFunction" ], Resource: "*" }
            ]
          })
        },
        assume_role_policy: Json.stringify({
          Version: "2012-10-17",
          Statement: [
            { Action: "sts:AssumeRole", Effect: "Allow", Principal: { Service: "states.amazonaws.com" } },
          ]
        })
      }
    }) as "role";

    new tf.TerraformResource({
      type: "aws_sfn_state_machine",
      attributes: {
        definition: Json.stringify(asl),
        role_arn: role.getStringMapAttribute("arn")
      },
    }) as "state_machine";
  }

  pub onSuccess(cb: inflight (Json?): void): void {

  }

  pub onError(cb: inflight (api.Error): void): void {

  }
  
  pub inflight start(ctx: Json?): void {

  }
  
  pub inflight status(): api.Status {
    return api.Status.NOT_STARTED;
  }
  
  pub inflight ctx(): Json {
    return {};
  }
  
  pub inflight error(): api.Error? {
    return nil;
  }
  
  pub inflight join(opts: util.WaitUntilProps?): Json {
    return {};
  }

  // --

  renderASL(steps: Array<api.Step>): Json {
    let endStateName = "__end__";

    let states = MutMap<Json>{};
    let var prev: api.Step? = nil;

    let addStates = (steps: Array<api.Step>): str? => {

      for i in 0..steps.length {
        let step = steps.at(i);
      
        if step.type == api.StepType.EXECUTE {
          let executeStep: api.ExecuteStep = unsafeCast(step);
  
          let handler = new cloud.Function(inflight (ctx) => {
            let output = executeStep.handler.handle(ctx) ?? {};
            return unsafeCast(u.mergeJson(ctx, output));
          }) as step.name;
  
          let state = MutJson {
            Type: "Task",
            Resource: "arn:aws:states:::lambda:invoke",
            OutputPath: "$.Payload",
            Parameters: {
              "Payload.$": "$",
              "FunctionName": aws.Function.from(handler)?.functionName,
            },
          };
  
          if let nextStep = steps.tryAt(i + 1) {
            state.set("Next", nextStep?.name);
          } else {
            state.set("End", true);
          }
  
          states.set(step.name, state);
  
        } elif step.type == api.StepType.CHECK {
          let checkStep: api.CheckStep = unsafeCast(step);
  
          let handler = new cloud.Function(inflight (ctx) => {
            let result = checkStep.predicate.handle(ctx);
            return unsafeCast({
              ctx: ctx,
              result: result
            });
          }) as step.name;
  
          let choiceState = "{step.name} (choice)";
  
          states.set(step.name, {
            Type: "Task",
            Resource: "arn:aws:states:::lambda:invoke",
            OutputPath: "$.Payload",
            Parameters: {
              "Payload.$": "$",
              "FunctionName": aws.Function.from(handler)?.functionName,
            },
            Next: choiceState,
          });

          states.set(choiceState, {
            Type: "Choice",
            Choices: [
              {
                Variable: "$.result",
                BooleanEquals: true,
                Next: addStates(checkStep.branches.ifTrue),
              },
            ],
            Default: addStates(checkStep.branches.ifFalse ?? [])
          });

        } else {
          throw "Unsupported step type: {step.type}";
        }
      }

      return steps.tryAt(0)?.name;
    };
    
    addStates(steps);

    return {
      StartAt: steps.tryAt(0)?.name ?? endStateName,
      States: states.copy(),
    };
  }
}