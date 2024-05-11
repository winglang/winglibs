bring cloud;
bring http;
bring "./util.w" as helpers;
bring "./message.w" as msg;
bring "./events.w" as events;
bring "./context.w" as context;
bring "cdktf" as cdktf;
bring util;
bring ui;

/// Properties for Slack bot
pub struct SlackbotProps {
  ignoreBots: bool?;
}


pub class Slackbot {
  api: cloud.Api;
  onEventHandlers: MutMap<inflight(context.CtxEventCallBack, Json):void>;
  ignoreBots: bool;
  botToken: cloud.Secret;

  new(props: SlackbotProps) {
    this.onEventHandlers = MutMap<inflight (context.CtxEventCallBack, Json): void>{};
    this.ignoreBots = props?.ignoreBots ?? true;
    this.botToken = new cloud.Secret(name: "{this.node.id}_botToken");
    this.api = new cloud.Api();

    if util.env("WING_TARGET") == "tf-aws" {
      new cdktf.TerraformOutput(value: "{this.api.url}/slack/events", description: "Slack Request URL");
    }

    this.api.post("/slack/events", inflight (req) => {
      let eventRequest = events.SlackEvent.fromJson(Json.parse(req.body!));
      if eventRequest.type == "url_verification" {
        let verificationEvent = events.VerificationEvent.fromJson(Json.parse(req.body!));
        return {
          status: 200,
          body: Json.stringify({
            challenge: verificationEvent.challenge
          })
        };
      }

      if eventRequest.type == "event_callback" {
        let callBackEvent = events.CallBackEvent.fromJson(Json.parse(req.body!)["event"]);

        if this.ignoreBots {
          if let bot_id = callBackEvent.bot_id {
            return {};
          }
          if let app_id = callBackEvent.app_id {
            return {};
          }
        }
        if let handler = this.onEventHandlers.tryGet(callBackEvent.type) {
          handler(new context.CtxEventCallBack(Json.parse(req.body!), this.botToken.value()), Json.parse(req.body!));
        }
      }
    });
  }

  /// Register an event handler
  pub onEvent(eventName: str, handler: inflight(context.CtxEventCallBack, Json): void) {
    this.onEventHandlers.set(eventName, handler);
  }

  /// Retrieve a channel object from a channel Id
  pub inflight getChannel(channelId: str): context.Channel {
    return new context.Channel(channelId, this.botToken.value());
  }
}