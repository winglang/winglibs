import os
from wing_helper import *

def handler(event, context):
  print(event)
  print(context)
  
  client = get_client("bucket")
  client.put("test.txt", "Hello, world!")
  
  return {
    "statusCode": 200,
    "body": "Hello!"
  }
