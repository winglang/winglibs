const AWS = require("aws-sdk");
const { createServer } = require("dynamodb-admin");

exports.startDbAdminProcess = async (options) => {
  const { endpoint } = options;
  const dynamodb = new AWS.DynamoDB({ 
    region: "local", 
    credentials: { accessKeyId: "local", secretAccessKey: "local" }, 
    endpoint,
  });
  const dynClient = new AWS.DynamoDB.DocumentClient({service: dynamodb});
  const app = createServer(dynamodb, dynClient);
  const server = app.listen(0, () => {
    if (server != null) {
      const port = server.address();
      console.log(`port=${port.port}`);
    }
  })
};
