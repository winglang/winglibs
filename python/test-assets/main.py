from wing import *

def handler(event, context):
  print(event)
  print(context)
  
  client = lifted("bucket")
  client.put("test.txt", "Hello, world!")
  
  return {
    "statusCode": 200,
    "body": "Hello!"
  }
