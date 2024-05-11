# slack

This library allows using Slack with Wing.

## Prerequisites

* [winglang](https://winglang.io)

## Installation

Use `npm` to install this library:

```sh
npm i @winglibs/slack
```
## Bring it

```js
bring slack;

let slackbot = new slack.Slackbot();

slackbot.onEvent("app_mention", inflight (ctx, event) => {
  let message = new slack.Message();
  message.addSection({
    fields: [
      {
        type: slack.FieldType.mrkdwn,
        text: "*Wow this is markdown!!*\ncool beans!!!"
      }
    ]
  });

  ctx.channel.post(message);
});
```

### Create your Slack App

1. Go to [Slack API](https://api.slack.com/apps) and create a new app.
2. Select Create from scratch
3. For the README example ensure you provide the following permissions:
  - "app_mentions:read",
  - "chat:write",
  - "chat:write.public",
  - "channels:read"
4. Navigate to events and subscribe to the following events:
  - app_mention
5. Navigate to OAuth & Permissions and install the app to your workspace
6. Copy the Bot User OAuth Token
7. Navigate `Event Subscriptions` and enable events, then subscribe to bot events:
  - app_mention

### Configuring Application Secrets

Before your bot can connect to Slack, you need to configure the required bot token as a secret in your project. You can do this by simply running the following command:

```sh
wing secrets -t PLATFORM_TARGET
```
When prompted paste the Bot User OAuth Token you copied earlier.

### Running in the Wing Simulator

When running in the Wing Simulator, you will need to expose the endpoint of the Slackbot API, this can be done through the simulator console by selecting `Open tunnel for this endpoint` 

![Open Tunnel](image.png)

Take this URL and navigate back to your Slack App, under the Event Subscriptions section, paste the URL into the Request URL field and append `/slack/events` to the end of the URL. 

### Running in AWS

After compiling and deploying your app using `tf-aws` you there will be an endpoint called `Request URL` that is part of the terraform output. The URL should end with `/slack/events`. Navigate back to your Slack App, under the Event Subscriptions section, paste the URL into the Request URL field and append `/slack/events` to the end of the URL.


## Post Directly to a Channel

If you want to post directly to a channel, you can do so by using the following code:

```js
bring slack;
bring cloud;

let slackbot = new slack.Slackbot();

let postMessage = new cloud.Function(inflight () => {
  let channel = slackbot.getChannel("C072T52EZ3Q");

  channel.postText("hello world!");
});
```