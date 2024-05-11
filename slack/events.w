pub struct SlackEvent {
  type: str;
}

pub struct CallBackEvent {
  user: str;
  type: str;
  ts: str;
  team: str;
  channel: str;
  event_ts: str;
  bot_id: str?;
  app_id: str?;
}

pub struct MessageCallBackEvent extends CallBackEvent {
  text: str;
}

pub struct VerificationEvent extends SlackEvent {
  token: str;
  challenge: str;
}
