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
pub struct AppProps {
  /// The bot token secret to use for the app
  botToken: cloud.Secret;
  /// Whether events from bot users should be ignored (default: true)
  ignoreBots: bool?;
}


pub class App {
  api: cloud.Api;
  eventHandlers: MutMap<inflight(context.EventContext, Json):void>;
  ignoreBots: bool;
  botToken: cloud.Secret;

  new(props: AppProps) {
    this.eventHandlers = MutMap<inflight (context.EventContext, Json): void>{};
    this.ignoreBots = props?.ignoreBots ?? true;
    this.botToken = props.botToken;
    this.api = new cloud.Api();

    if util.env("WING_TARGET") == "tf-aws" {
      new cdktf.TerraformOutput(value: "{this.api.url}/slack/events", description: "Slack Request URL") as "Slack_Request_Url";
    }

    this.api.post("/slack/events", inflight (req) => {
      let eventRequest = events.SlackEvent.parseJson(req.body!);
      if eventRequest.type == "url_verification" {
        let verificationEvent = events.VerificationEvent.parseJson(req.body!);
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
          if callBackEvent.bot_id != nil  || callBackEvent.app_id != nil {
            return {};
          }
        }
        if let handler = this.eventHandlers.tryGet(callBackEvent.type) {
          // TODO: pass bot token as cloud.Secret rather than str once: https://github.com/winglang/winglibs/pull/229 is complete
          handler(new context.EventContext(Json.parse(req.body!), this.botToken.value()), Json.parse(req.body!));
        }
      }
    });
  }

  /// Register an event handler
  pub onEvent(eventName: str, handler: inflight(context.EventContext, Json): void) {
    this.eventHandlers.set(eventName, handler);
  }

  /// Retrieve a channel object from a channel Id
  pub inflight channel(channelId: str): context.Channel {
    return new context.Channel(channelId, this.botToken.value());
  }
}