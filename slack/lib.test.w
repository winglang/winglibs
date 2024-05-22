bring cloud;
bring expect;
bring http;
bring "./lib.w" as slack;
bring "./message.w" as msg;
bring "./events.w" as events;

let token = new cloud.Secret();
let app = new slack.App(botToken: token);

app.onEvent("app_mention", inflight (ctx, event) => {
  // Have the call just return the response from posting to thread (for testing)
  let res = ctx.thread.post("message");
  return res;
});

test "app_mention event" {
  let endpoint = app.api.url;
  let callbackEvent: events.CallbackEvent = {
    user: "FakeUser",
    type: "app_mention",
    ts: "00000000",
    team: "FakeTeam",
    event_ts: "0000000",
    channel: "FakeChannel"
  };

  let slackEvent = {
    type: "event_callback",
    event: callbackEvent
  };

  let res = http.post("{endpoint}/slack/events", {
    body: Json.stringify(slackEvent)
  });
  
  expect.equal(Json.parse(res.body), 
    {
      status: 200,
      body: "Totally sent that string to the thread :)"
    }
  );
}

test "test sending plain text to channel" {
  let channel = app.channel("ABC123");
  let res = channel.post("Hi");

  expect.equal(res, 
    {
      status: 200,
      body: "Totally sent that string to the channel: ABC123 :)"
    }
  );
}

test "sending block message to channel" {
  let channel = app.channel("FAKE_CHANNEL");
  let message = new msg.Message();

  message.addSection(
    {
      fields: [
      {
        type: msg.FieldType.mrkdwn,
        text: "Hello there!"
      }
    ]
  });

  let res = channel.postMessage(message);

  expect.equal(res, 
    {
     status: 200,
     body: "Totally sent that message to the channel: FAKE_CHANNEL :)" 
    }
  );
}