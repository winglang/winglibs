pub struct SlackEvent {
  type: str;
}

pub struct CallbackEvent {
  user: str;
  type: str;
  ts: str;
  team: str;
  channel: str;
  event_ts: str;
  bot_id: str?;
  app_id: str?;
}

pub struct MessageCallbackEvent extends CallbackEvent {
  text: str;
}

pub struct VerificationEvent extends SlackEvent {
  token: str;
  challenge: str;
}
