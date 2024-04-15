from wing import *

def handler(event, context):
  print(event)
  print(context)
  
  client_get = lifted("bucket-get")
  value = client_get.get("test.txt")
  
  client_put = lifted("bucket-put")
  client_put.put("test.txt", value)
  
  return {
    "statusCode": 200,
    "body": "Hello!"
  }
