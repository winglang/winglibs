const { EventBridgeClient, PutEventsCommand } = require("@aws-sdk/client-eventbridge");

const putEvent = async (eventBridgeName, event) => {
  console.log(`Publishing event to EventBridge: ${eventBridgeName} - ${JSON.stringify(event)}`);
  const client = new EventBridgeClient({ region: process.env.AWS_REGION });
  const input = {
    Entries: [
      {
        Source: event.source,
        DetailType: event.detailType,
        Detail: JSON.stringify(event.detail),
        EventBusName: eventBridgeName,
        Resources: [event.resource],
      },
    ],
  };
  const command = new PutEventsCommand(input);
  await client.send(command);
}

module.exports = {
  putEvent
}
