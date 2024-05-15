from wing import *
import os

def handler(event, context):
  print(event)
  print(context)

  fooEnv = os.getenv("FOO")
  payload = from_function_event(event)
  
  client = lifted("bucket")
  value = client.get("test.txt")
  client.put("test.txt", value + payload + fooEnv)
  
  return {
    "statusCode": 200,
    "body": "Hello!"
  }

def queue_consumer_handler(event, context):
  print(event)
  print(context)

  payload = from_queue_event(event)
  for p in payload:
    client_put = lifted("bucket")
    client_put.put("queue.txt", p)
  
  return {
    "statusCode": 200,
    "body": "Hello from Queue Consumer!"
  }

def topic_onmessage_handler(event, context):
  print(event)
  print(context)

  payload = from_topic_event(event)
  for p in payload:
    client_put = lifted("bucket")
    client_put.put("topic.txt", p)

  return {
    "statusCode": 200,
    "body": "Hello from Topic OnMessage!"
  }

def bucket_oncreate_handler(event, context):
  print(event)
  print(context)

  payload = from_bucket_event(event)
  for p in payload:
    client_put = lifted("bucket")
    client_put.put(p.key, p.type)

  return {
    "statusCode": 200,
    "body": "Hello from Bucket OnCreate!"
  }
