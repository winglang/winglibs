const {
  InvokeCommand,
  LambdaClient,
} = require("@aws-sdk/client-lambda");
const { fromUtf8, toUtf8 } = require("@smithy/util-utf8");

module.exports.FunctionClient = class FunctionClient {
  constructor(functionArn) {
    this.functionArn = functionArn;
    this.lambdaClient = new LambdaClient({});
  } 

  async invoke(payload) {
    const command = new InvokeCommand({
      FunctionName: this.functionArn,
      Payload: fromUtf8(
        payload !== undefined ? JSON.stringify(payload) : "{}"
      ),
    });
    const response = await this.lambdaClient.send(command);
    return parseCommandOutput(response, this.functionArn);
  }
}


function parseCommandOutput(
  payload,
  functionArn
) {
  if (payload.FunctionError) {
    let errorText = toUtf8(payload.Payload);
    let errorData;
    try {
      errorData = JSON.parse(errorText);
    } catch (_) {}

    if (errorData && "errorMessage" in errorData) {
      const newError = new Error(
        `Invoke failed with message: "${
          errorData.errorMessage
        }"\nLogs: ${cloudwatchLogsPath(functionArn)}`
      );
      newError.name = errorData.errorType;
      newError.stack = errorData.trace?.join("\n");
      throw newError;
    }

    throw new Error(
      `Invoke failed with message: "${
        payload.FunctionError
      }"\nLogs: ${cloudwatchLogsPath(functionArn)}\nFull Error: "${errorText}"`
    );
  }

  if (!payload.Payload) {
    return undefined;
  } else {
    const returnObject = toUtf8(payload.Payload);
    return returnObject === null ? undefined : returnObject;
  }
}

function cloudwatchLogsPath(functionArn) {
  const functionName = encodeURIComponent(functionArn.split(":").slice(-1)[0]);
  const region = functionArn.split(":")[3];
  return `https://${region}.console.aws.amazon.com/cloudwatch/home?region=${region}#logsV2:log-groups/log-group/%2Faws%2Flambda%2F${functionName}`;
}
