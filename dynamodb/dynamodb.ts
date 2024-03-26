import * as dynamodb from "@aws-sdk/client-dynamodb";
import { DynamoDBDocument } from "@aws-sdk/lib-dynamodb";
import { unmarshall } from "@aws-sdk/util-dynamodb";

import type extern from "./dynamodb.extern";

export { unmarshall };

// @ts-ignore
export const createClient: extern["createClient"] = async (options) => {
  // @ts-ignore
  return new dynamodb.DynamoDB(options);
};

// @ts-ignore
export const createDocumentClient: extern["createDocumentClient"] = async (
  options
) => {
  const client = await createClient(options);
  // @ts-ignore
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

import * as streams from "@aws-sdk/client-dynamodb-streams";

interface ProcessStreamRecordsOptions {
  batchSize?: number;
  startingPosition?: "LATEST" | "TRIM_HORIZON";
}

const processStreamRecords = async (
  client: streams.DynamoDBStreams,
  StreamArn: string,
  handler: (record: any) => void | Promise<void>,
  options?: ProcessStreamRecordsOptions
) => {
  const { StreamDescription } = await client.describeStream({ StreamArn });

  for (const { ShardId } of StreamDescription?.Shards ?? []) {
    const shardIteratorData = await client.getShardIterator({
      StreamArn,
      ShardId,
      ShardIteratorType: options?.startingPosition ?? "LATEST",
    });

    let shardIterator = shardIteratorData.ShardIterator;
    while (shardIterator) {
      const recordsData = await client.getRecords({
        ShardIterator: shardIterator,
        Limit: options?.batchSize,
      });

      for (const record of recordsData?.Records ?? []) {
        try {
          await handler({
            eventId: record.eventID,
            eventName: record.eventName,
            dynamodb: {
              ApproximateCreationDateTime:
                record.dynamodb?.ApproximateCreationDateTime,
              Keys: record.dynamodb?.Keys
                ? unmarshall(record.dynamodb.Keys, {
                    wrapNumbers: true,
                  })
                : undefined,
              NewImage: record.dynamodb?.NewImage
                ? unmarshall(record.dynamodb.NewImage, {
                    wrapNumbers: true,
                  })
                : undefined,
              OldImage: record.dynamodb?.OldImage
                ? unmarshall(record.dynamodb.OldImage, {
                    wrapNumbers: true,
                  })
                : undefined,
              SequenceNumber: record.dynamodb?.SequenceNumber,
              SizeBytes: record.dynamodb?.SizeBytes,
              StreamViewType: record.dynamodb?.StreamViewType,
            },
          });
        } catch (error) {
          console.error("Error processing stream record:", error, record);
        }
      }

      shardIterator = recordsData.NextShardIterator;

      // AWS DynamoDB fetches records 4 times a second.
      await new Promise((resolve) => setTimeout(resolve, 250));
    }
  }
};

const processRecords = async (
  endpoint: string,
  tableName: string,
  handler: (record: any) => void | Promise<void>,
  options?: ProcessStreamRecordsOptions
) => {
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
        Streams?.map(({ StreamArn }) =>
          processStreamRecords(client, StreamArn!, handler, options)
        ) ?? []
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

export const processRecordsAsync: extern["processRecordsAsync"] = async (
  endpoint,
  tableName,
  handler,
  options
) => {
  const startingPosition = options?.startingPosition;
  if (startingPosition !== "TRIM_HORIZON" && startingPosition !== "LATEST") {
    throw new Error("Invalid starting position");
  }
  processRecords(endpoint, tableName, handler, {
    ...options,
    startingPosition,
  }).catch((error) => {
    if (error.message.includes("ECONNREFUSED")) {
      // Ignore. This error happens when reloading the console.
      // We can safely end the execution here.
    } else {
      console.error(error);
    }
  });
};
