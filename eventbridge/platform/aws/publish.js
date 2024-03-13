const { EventBridgeClient, PutEventsCommand } = require("@aws-sdk/client-eventbridge");

const client = new EventBridgeClient();

const _putEvent = async (eventBridgeName, input) => {
  console.log(`Publishing event to EventBridge: ${eventBridgeName} - ${JSON.stringify(input)}`);  
  const command = new PutEventsCommand(input);
  await client.send(command);
}

module.exports = {
  _putEvent
}
