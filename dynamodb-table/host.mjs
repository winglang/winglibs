export { default as getPort } from "get-port";

import * as child_process from "node:child_process";

// export interface SpawnOptions {
//   command: string;
//   arguments: string[];
//   cwd?: string;
//   env?: Record<string, string>;
//   onData?: (data: string) => void;
// }

export const spawn = async (options) => {
  let child = child_process.spawn(options.command, options.arguments, {
    cwd: options.cwd,
    env: options.env,
  });

  child.stdout.on("data", (data) => options.onData?.(data.toString()));
  child.stderr.on("data", (data) => options.onData?.(data.toString()));

  return {
    kill() {
      child.kill("SIGINT");
    },
  };
};

import * as dynamodb from "@aws-sdk/client-dynamodb";

// export interface CreateClientOptions {
//   endpoint: string;
// }

export const createClient = (endpoint) => {
  return new dynamodb.DynamoDB({
    region: "local",
    credentials: {
      accessKeyId: "local",
      secretAccessKey: "local",
    },
    endpoint,
  });
};

import * as streams from "@aws-sdk/client-dynamodb-streams";

// export const createStreamsClient = (endpoint) => {
//   return new streams.DynamoDBStreams({
//     region: "local",
//     credentials: {
//       accessKeyId: "local",
//       secretAccessKey: "local",
//     },
//     endpoint,
//   });
// };

/**
 * @param {import("@aws-sdk/client-dynamodb-streams").DynamoDBStreams} client
 * @param {string} StreamArn
 */
const processStreamRecords = async (client, StreamArn) => {
  try {
    // Describe the stream to get the shards
    const { StreamDescription } = await client.describeStream({ StreamArn });

    for (const { ShardId } of StreamDescription.Shards) {
      // Get a shard iterator for the current shard
      const shardIteratorData = await client.getShardIterator({
        StreamArn,
        ShardId,
        ShardIteratorType: "TRIM_HORIZON",
      });

      let shardIterator = shardIteratorData.ShardIterator;

      while (shardIterator) {
        // Use the shard iterator to read stream records
        const recordsData = await client.getRecords({
          ShardIterator: shardIterator,
        });

        // Process each record
        for (const record of recordsData.Records) {
          console.log("Record:", record);
          // Here you would typically process the record
          // For example, you could invoke a Lambda function with the record data
        }

        // Get the next shard iterator
        shardIterator = recordsData.NextShardIterator;

        // Sleep for a short time before the next get records request to avoid empty responses
        await new Promise((resolve) => setTimeout(resolve, 250));
      }
    }
  } catch (error) {
    console.error("Error processing stream records:", error);
  }
};

const processRecords = async (endpoint, tableName) => {
  const client = new streams.DynamoDBStreams({
    region: "local",
    credentials: {
      accessKeyId: "local",
      secretAccessKey: "local",
    },
    endpoint,
  });

  const { Streams } = await client.listStreams({ TableName: tableName });
  console.log({ Streams });

  for (const { StreamArn } of Streams) {
    await processStreamRecords(client, StreamArn);
  }
};

export const processRecordsAsync = async (endpoint, tableName) => {
  processRecords(endpoint, tableName);
};
