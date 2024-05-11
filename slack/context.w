bring "./message.w" as msg;
bring "./util.w" as helpers;
bring "./events.w" as events;

/// The bahvioral interface of a sender
pub inflight interface ISender {
  inflight post(message: msg.Message): void;
  inflight postText(message: str): void;
}

/// Represents the context of a slack channel
pub inflight class Channel impl ISender {
  /// The channel id
  pub channel_id: str;
  botToken: str;
  
  new (channel: str, botToken: str) {
    this.channel_id = channel;
    this.botToken = botToken;
  }

  /// Post a message block to a channel
  pub inflight post(message: msg.Message): void {
    helpers.SlackUtils.post(
      {
        channel: this.channel_id,
        blocks: message.buildMessage(),
      },
      this.botToken
    );
  }

  /// Post raw text to a channel
  pub inflight postText(message: str): void {
    helpers.SlackUtils.post(
      {
        channel: this.channel_id,
        text: message
      },
      this.botToken
    );
  }
}

/// Represents the context of a slack thread
pub inflight class Thread impl ISender {
  /// The channel id
  pub channel_id: str;
  /// The thread timestamp
  pub thread_ts: str;
  botToken: str;

  new(channel: str, thread_ts: str, botToken: str) {
    this.channel_id = channel;
    this.thread_ts = thread_ts;
    this.botToken = botToken;
  }

  /// Post a message to a thread
  pub inflight post(message: msg.Message) {
    helpers.SlackUtils.post(
      {
        channel: this.channel_id,
        thread_ts: this.thread_ts,
        blocks: message.buildMessage()
      },
      this.botToken
    );
  } 

  /// Post raw text to a thread
  pub inflight postText(message: str) {
    helpers.SlackUtils.post(
      {
        channel: this.channel_id,
        thread_ts: this.thread_ts,
        text: message
      },
      this.botToken
    );
  }
}

/// Represents the context of an event callback
pub inflight class CtxEventCallBack {
  pub thread: Thread;
  pub channel: Channel;
  new (rawContext: Json, botToken: str) {
    let callBackEvent = events.CallBackEvent.fromJson(rawContext["event"]);
    this.thread = new Thread(callBackEvent.channel, callBackEvent.event_ts, botToken);
    this.channel = new Channel(callBackEvent.channel, botToken);
  }
}
