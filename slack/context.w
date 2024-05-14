bring "./message.w" as msg;
bring "./util.w" as helpers;
bring "./events.w" as events;

/// The bahvioral interface of a thread
pub inflight interface IThread {
  inflight postMessage(message: msg.Message): void;
  inflight post(message: str): void;
}

/// Represents the context of a slack channel
pub inflight class Channel impl IThread {
  /// The channel id
  pub id: str;
  botToken: str;
  
  new (channel: str, botToken: str) {
    this.id = channel;
    this.botToken = botToken;
  }

  /// Post a message block to a channel
  pub inflight postMessage(message: msg.Message): void {
    helpers.SlackUtils.post(
      {
        channel: this.id,
        blocks: message.toJson(),
      },
      this.botToken
    );
  }

  /// Post raw text to a channel
  pub inflight post(message: str): void {
    helpers.SlackUtils.post(
      {
        channel: this.id,
        text: message
      },
      this.botToken
    );
  }
}

/// Represents the context of a slack thread
pub inflight class Thread impl IThread {
  /// The channel context
  pub channel: Channel;
  /// The thread timestamp
  pub timestamp: str;
  botToken: str;

  new(channel: str, thread_ts: str, botToken: str) {
    this.channel = new Channel(channel, botToken);
    this.timestamp = thread_ts;
    this.botToken = botToken;
  }

  /// Post a message to a thread
  pub inflight postMessage(message: msg.Message) {
    helpers.SlackUtils.post(
      {
        channel: this.channel.id,
        thread_ts: this.timestamp,
        blocks: message.toJson()
      },
      this.botToken
    );
  } 

  /// Post raw text to a thread
  pub inflight post(message: str) {
    helpers.SlackUtils.post(
      {
        channel: this.channel.id,
        thread_ts: this.timestamp,
        text: message
      },
      this.botToken
    );
  }
}

/// Represents the context of an event callback
pub inflight class EventContext {
  pub thread: Thread;
  pub channel: Channel;
  new (rawContext: Json, botToken: str) {
    let callBackEvent = events.CallBackEvent.fromJson(rawContext["event"]);
    this.thread = new Thread(callBackEvent.channel, callBackEvent.event_ts, botToken);
    this.channel = new Channel(callBackEvent.channel, botToken);
  }
}
