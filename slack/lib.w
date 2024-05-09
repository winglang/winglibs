bring cloud;

struct SlackEvent {
  type: str;
}

struct CallBackEvent {
  user: str;
  type: str;
  ts: str;
  team: str;
  channel: str;
  event_ts: str;
}

struct MessageCallBackEvent extends CallBackEvent {
  text: str;
}

struct VerificationEvent extends SlackEvent {
  token: str;
  challenge: str;
}

pub class Slackbot {
  api: cloud.Api;
  mapping: MutMap<inflight():void>;

  new() {
    this.mapping = MutMap<inflight (): void>{};
    this.api = new cloud.Api();
    this.api.post("/slack/events", inflight (req) => {
      let eventRequest = SlackEvent.fromJson(Json.parse(req.body!));
      if eventRequest.type == "url_verification" {
        let verificationEvent = VerificationEvent.fromJson(req.body!);
        return {
          status: 200,
          body: Json.stringify({
            challenge: verificationEvent.challenge
          })
        };
      }

      if eventRequest.type == "event_callback" {
        let callBackEvent = CallBackEvent.fromJson(Json.parse(req.body!)["event"]);
        if callBackEvent.type == "message" {
          let messageCallBack = MessageCallBackEvent.fromJson(Json.parse(req.body!)["event"]);
          log("Someone Sent a message of: {messageCallBack.text}");
        }
        log("CallBack Event Recieved: {Json.stringify(callBackEvent, indent: 2)}");
      }

      log("Unhandled Event Type: {eventRequest.type}");
      log(Json.stringify(Json.parse(req.body!), indent: 2));
    });
  }
}