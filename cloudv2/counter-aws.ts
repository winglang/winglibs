import {
  UpdateItemCommand,
  GetItemCommand,
  DynamoDBClient,
} from "@aws-sdk/client-dynamodb";

import types from "./counter-aws.extern";

const AMOUNT_TOKEN = "amount";
const INITIAL_VALUE_TOKEN = "initial";
const VALUE_ATTRIBUTE = "counter_value";
const SET_VALUE = "set_value";

const client = new DynamoDBClient();

export const _inc: types["_inc"] = async (
  amount,
  key,
  tableName,
  hashKey,
  initial
) => {
  const command = new UpdateItemCommand({
    TableName: tableName,
    Key: { [hashKey]: { S: key } },
    UpdateExpression: `SET ${VALUE_ATTRIBUTE} = if_not_exists(${VALUE_ATTRIBUTE}, :${INITIAL_VALUE_TOKEN}) + :${AMOUNT_TOKEN}`,
    ExpressionAttributeValues: {
      [`:${AMOUNT_TOKEN}`]: { N: `${amount}` },
      [`:${INITIAL_VALUE_TOKEN}`]: { N: `${initial}` },
    },
    ReturnValues: "UPDATED_NEW",
  });

  const result = await client.send(command);
  let newValue = result.Attributes?.[VALUE_ATTRIBUTE].N;
  if (!newValue) {
    throw new Error(`${VALUE_ATTRIBUTE} attribute not found on table.`);
  }

  // return the old value
  return parseInt(newValue) - amount;
};

export const _dec: types["_dec"] = async (
  amount,
  key,
  tableName,
  hashKey,
  initial
) => {
  return _inc(-1 * amount, key, tableName, hashKey, initial);
};

export const _peek: types["_peek"] = async (
  key,
  tableName,
  hashKey,
  initial
) => {
  const command = new GetItemCommand({
    TableName: tableName,
    Key: { [hashKey]: { S: key } },
  });

  const result = await client.send(command);
  let value = result.Item?.[VALUE_ATTRIBUTE].N;
  if (!value) {
    return initial;
  }

  return parseInt(value);
};

export const _set: types["_set"] = async (value, key, tableName, hashKey) => {
  const command = new UpdateItemCommand({
    TableName: tableName,
    Key: { [hashKey]: { S: key } },
    UpdateExpression: `SET ${VALUE_ATTRIBUTE} = :${SET_VALUE}`,
    ExpressionAttributeValues: {
      [`:${SET_VALUE}`]: { N: `${value}` },
    },
    ReturnValues: "UPDATED_NEW",
  });

  await client.send(command);
};
