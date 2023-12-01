bring cloud;
bring util;
bring "./lib.w" as lib;

pub struct FIFOMessage {
  body: str;
  deduplicationId: str;
  groupId: str;
}

pub class FIFOQueue {
  table: lib.Table;

  new() {
    this.table = new lib.Table(
      attributeDefinitions: [
        {
          attributeName: "pk",
          attributeType: "S",
        },
      ],
      keySchema: [
        {
          attributeName: "pk",
          keyType: "HASH",
        },
      ],
      timeToLiveAttribute: "ttl",
    );
  }

  pub setConsumer(handler: inflight (FIFOMessage): void) {
    this.table.setStreamConsumer(inflight (record) => {
      if let item = record.dynamodb.NewImage {
        if item.get("pk").get("S").asStr().startsWith("GROUP_ID#") {
          handler(
            body: item.get("body").get("S").asStr(),
            deduplicationId: item.get("deduplicationId").get("S").asStr(),
            groupId: item.get("groupId").get("S").asStr(),
          );
        }
      }
    });
  }

  pub inflight sendMessage(message: FIFOMessage) {
    let now = std.Datetime.utcNow();
    let timestamp = now.timestampMs;
    // Amazon SQS has a deduplication interval of 5 minutes.
    let ttl = now.timestamp + 5m.seconds;
    try {
      this.table.transactWrite(
        transactItems: [
          {
            put: {
              item: {
                pk: "GROUP_ID#{message.groupId}",
                deduplicationId: message.deduplicationId,
                groupId: message.groupId,
                body: message.body,
                timestamp: timestamp,
              },
            },
          },
          {
            put: {
              item: {
                pk: "DEDUPLICATION_ID#{message.deduplicationId}",
                deduplicationId: message.deduplicationId,
                groupId: message.groupId,
                body: message.body,
                timestamp: timestamp,
                ttl: ttl,
              },
              conditionExpression: "attribute_not_exists(pk)",
            },
          },
        ],
      );
    } catch error {
      if error == "Transaction cancelled, please refer cancellation reasons for specific reasons [None, ConditionalCheckFailed]" {
        log("Message with deduplicationId=[{message.deduplicationId}] already exists");
      } else {
        throw error;
      }
    }
  }
}
