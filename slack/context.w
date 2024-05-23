bring "./message.w" as msg;
bring "./util.w" as helpers;
bring "./events.w" as events;

/// The bahvioral interface of a thread
pub inflight interface IThread {
  postMessage(message: msg.Message): Json;
  post(message: str): Json;
}

/// Represents the context of a slack channel
pub inflight class Channel impl IThread {
  /// The channel id
  pub id: str;
  token: str;
  
  new(channel: str, token: str) {
    this.id = channel;
    this.token = token;
  }

  /// Post a message block to a channel
  pub inflight postMessage(message: msg.Message): Json {
    return helpers.SlackUtils.post(
      {
        channel: this.id,
        blocks: message.toJson(),
      },
      this.token
    );
  }

  /// Post raw text to a channel
  pub inflight post(message: str): Json {
    return helpers.SlackUtils.post(
      {
        channel: this.id,
        text: message
      },
      this.token
    );
  }
}

/// Represents the context of a slack thread
pub inflight class Thread impl IThread {
  /// The channel context
  pub channel: Channel;
  /// The thread timestamp
  pub timestamp: str;
  token: str;

  new(channel: str, thread_ts: str, token: str) {
    this.channel = new Channel(channel, token);
    this.timestamp = thread_ts;
    this.token = token;
  }

  /// Post a message to a thread
  pub inflight postMessage(message: msg.Message): Json {
    return helpers.SlackUtils.post(
      {
        channel: this.channel.id,
        thread_ts: this.timestamp,
        blocks: message.toJson()
      },
      this.token
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
      this.token
    );
  }
}

/// Only used for internal testing
pub inflight class MockChannel extends Channel {
  new(channel: str, token: str) {
    super(channel, token);
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

/// Only used for internal testing
inflight class MockThread extends Thread {
  new(channel: str, thread_ts: str, token: str) {
    super(channel, thread_ts, token);
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
  new(rawContext: Json, token: str) {
    let callBackEvent = events.CallbackEvent.fromJson(rawContext["event"]);
    this.thread = new Thread(callBackEvent.channel, callBackEvent.event_ts, token);
    this.channel = new Channel(callBackEvent.channel, token);
  }
}

/// Internally used for mocking event context
pub inflight class EventContext_Mock extends EventContext {
  pub thread: Thread;
  pub channel: Channel;
  new(rawContext: Json, token: str) {
    super(rawContext, "");
    let callBackEvent = events.CallbackEvent.fromJson(rawContext["event"]);
    this.thread = new MockThread(callBackEvent.channel, callBackEvent.event_ts, token);
    this.channel = new MockChannel(callBackEvent.channel, token);
  }
}