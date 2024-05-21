bring "./message.w" as msg;
bring "./util.w" as helpers;
bring "./events.w" as events;

/// The bahvioral interface of a thread
pub inflight interface IThread {
  inflight postMessage(message: msg.Message): Json;
  inflight post(message: str): Json;
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
  pub inflight postMessage(message: msg.Message): Json {
    return helpers.SlackUtils.post(
      {
        channel: this.id,
        blocks: message.toJson(),
      },
      this.botToken
    );
  }

  /// Post raw text to a channel
  pub inflight post(message: str): Json {
    return helpers.SlackUtils.post(
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
  pub inflight postMessage(message: msg.Message): Json {
    return helpers.SlackUtils.post(
      {
        channel: this.channel.id,
        thread_ts: this.timestamp,
        blocks: message.toJson()
      },
      this.botToken
    );
  } 

  /// Post raw text to a thread
  pub inflight post(message: str): Json {
    return helpers.SlackUtils.post(
      {
        channel: this.channel.id,
        thread_ts: this.timestamp,
        text: message
      },
      this.botToken
    );
  }
}

pub inflight class Channel_Mock extends Channel {
  new(channel: str, botToken: str) {
    super(channel, botToken);
  }

  pub inflight post(message: str): Json {
    return {
      status: 200,
      body: "Totally sent that string to the channel: {this.id} :)"
    };
  }

  pub inflight postMessage(message: msg.Message): Json {
    return {
      status: 200,
      body: "Totally sent that message to the channel: {this.id} :)"
    };
  }
}

pub inflight class Thread_Mock extends Thread {
  new(channel: str, thread_ts: str, botToken: str) {
    super(channel, thread_ts, botToken);
  }

  pub inflight post(message: str): Json {
    return {
      status: 200,
      body: "Totally sent that string to the thread :)"
    };
  }

  pub inflight postMessage(message: msg.Message): Json {
    return {
      status: 200,
      body: "Totally sent that message to the thread :)"
    };
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

/// Internally used for mocking event context
pub inflight class EventContext_Mock extends EventContext {
  pub thread: Thread;
  pub channel: Channel;
  new (rawContext: Json, botToken: str) {
    super(rawContext, "");
    let callBackEvent = events.CallBackEvent.fromJson(rawContext["event"]);
    this.thread = new Thread_Mock(callBackEvent.channel, callBackEvent.event_ts, botToken);
    this.channel = new Channel_Mock(callBackEvent.channel, botToken);
  }
}