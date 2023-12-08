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
import { DynamoDBDocument } from "@aws-sdk/lib-dynamodb";

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

export const createDocumentClient = (endpoint) => {
  const client = createClient(endpoint);
  return DynamoDBDocument.from(client, {
    marshallOptions: {
      removeUndefinedValues: true,
      convertEmptyValues: true,
    },
    unmarshallOptions: {
      wrapNumbers: true,
    },
  });
};

// const x =  DynamoDBDocument.from();
// x.transactWrite({
//   TransactItems: [
//     {
//       Put: {}
//     }
//   ]
// })

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
 * @param {(record: any) => void|Promise<void>} handler
 */
const processStreamRecords = async (client, StreamArn, handler) => {
  // while (true) {
  // try {
  const { StreamDescription } = await client.describeStream({ StreamArn });

  for (const { ShardId } of StreamDescription.Shards) {
    const shardIteratorData = await client.getShardIterator({
      StreamArn,
      ShardId,
      ShardIteratorType: "TRIM_HORIZON",
    });

    let shardIterator = shardIteratorData.ShardIterator;
    while (shardIterator) {
      const recordsData = await client.getRecords({
        ShardIterator: shardIterator,
      });

      for (const record of recordsData.Records) {
        try {
          await handler(record);
        } catch (error) {
          console.error("Error processing stream record:", error, record);
        }
      }

      shardIterator = recordsData.NextShardIterator;

      // AWS DynamoDB fetches records 4 times a second.
      await new Promise((resolve) => setTimeout(resolve, 250));
    }
  }
  // } catch (error) {
  //   console.error("Error processing stream records:", error);
  //   console.error("error name", error.name);
  //   // if (error.name === "TrimmedDataAccessException") {
  //   //   // Ignore...
  //   // } else {
  //   //   throw error;
  //   // }
  // }

  //   console.log("something went wrong");
  //   await new Promise((resolve) => setTimeout(resolve, 250));
  // }
};

const processRecords = async (endpoint, tableName, handler) => {
  while (true) {
    const client = new streams.DynamoDBStreams({
      region: "local",
      credentials: {
        accessKeyId: "local",
        secretAccessKey: "local",
      },
      endpoint,
    });

    try {
      const { Streams } = await client.listStreams({ TableName: tableName });
      await Promise.all(
        Streams.map(({ StreamArn }) =>
          processStreamRecords(client, StreamArn, handler)
        )
      );
    } catch (error) {
      if (error.message.includes("ECONNREFUSED")) {
        // Stop processing records when the host is down.
        throw error;
      } else if (error.name === "TrimmedDataAccessException") {
        // Ignore. This error seems to be a bug in DynamoDB Local.
        // The desired behavior is to retry processing the records.
      } else if (error.name === "ExpiredIteratorException") {
        // Ignore. This error happens after the computer wakes up from sleep.
      } else {
        throw error;
      }
      await new Promise((resolve) => setTimeout(resolve, 250));
    }
  }
};

export const processRecordsAsync = async (endpoint, tableName, handler) => {
  processRecords(endpoint, tableName, handler).catch((error) => {
    if (error.message.includes("ECONNREFUSED")) {
      // Ignore. This error happens when reloading the console.
      // We can safely end the execution here.
    } else {
      console.error(error);
    }
  });
};
