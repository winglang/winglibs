from wing import *
import os

def handler(event, context):
  print(event)
  print(context)

  payload = from_function_event(event)
  foo_env = os.getenv("FOO")
  
  email_client = lifted("email")
  email_client.send_email(Source="eladc@wing.cloud", Destination={'ToAddresses': ['eladc@monada.co',],},Message={'Subject': {'Data': 'Winglang Test Email!',},'Body': {'Text': {'Data': 'Hello from Python!',},}},)

  mobile_client = lifted("sms")
  mobile_client.publish(
    Message="Hello from Python!",
    Subject="Test Subject",
    PhoneNumber="+972503292946",
  )

  table = lifted("table")
  response = table.get(Key={"id":"test"})
  table_value = response["Item"]["body"]
  
  custom = lifted("custom")
  custom_data = custom["liftData"]["info"]

  bucket = lifted("bucket")
  value = bucket.get("test.txt")
  bucket.put("test.txt", value + payload + foo_env + table_value + custom_data)

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
  foo = os.getenv("FOO")

  client_put = lifted("bucket")
  client_put.put(req["path"], json.dumps(req))

  return from_api_response({
    "status": 200,
    "body": "Hello from Api Handler!",
    "headers": {
      "header1": "value1",
      "foo": foo
    }
  })
