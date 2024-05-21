bring cloud;
bring expect;
bring "./lib.w" as slack;
bring "./message.w" as msg;

let token = new cloud.Secret();
let app = new slack.App(botToken: token);

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