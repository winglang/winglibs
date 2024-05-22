from wing import *
import os

def handler(event, context):
  print(event)
  print(context)

  foo_env = os.getenv("FOO")
  payload = from_function_event(event)
  
  email_client = lifted("email")
  email_client.send_email(Source="bot@wing.cloud", Destination={'ToAddresses': ['bot@monada.co',],},Message={'Subject': {'Data': 'Winglang Test Email!',},'Body': {'Text': {'Data': 'Hello from Python!',},}},)

  mobile_client = lifted("sms")
  mobile_client.publish(
    Message="Hello from Python!",
    Subject="Test Subject",
    PhoneNumber="1234567890",
  )

  table = lifted("table")
  response = table.get(Key={'id':{'S':"test"}})
  table_value = response.get("Item").get("body").get("S")

  bucket = lifted("bucket")
  value = bucket.get("test.txt")
  bucket.put("test.txt", value + payload + foo_env + table_value)
  
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

def api_handler(event, context):
  print(event)
  print(context)

  req = from_api_event(event)
  client_put = lifted("bucket")
  client_put.put(req.path, req.toJSON())

  return from_api_response({
    "status": 200,
    "body": "Hello from Api Handler!",
    "headers": {
      "header1": "value1"
    }
  })
