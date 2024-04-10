import requests
import boto3
from botocore.exceptions import ClientError
import json
from typing import Optional, List
import os

class BucketClient_aws:
  def __init__(self, bucket_name: str, s3_client: boto3.client = None):
    self.bucket_name = bucket_name
    self.s3_client = s3_client or boto3.client('s3')

  def exists(self, key: str) -> bool:
    try:
      self.s3_client.head_object(Bucket=self.bucket_name, Key=key)
      return True
    except ClientError as e:
      if e.response['Error']['Code'] == '404':
        return False
      raise e

  def put(self, key: str, body: str, opts: Optional[dict] = None):
    content_type = opts.get('contentType', 'application/octet-stream') if opts else 'application/octet-stream'
    self.s3_client.put_object(Bucket=self.bucket_name, Key=key, Body=body, ContentType=content_type)

  def put_json(self, key: str, body: dict):
    self.put(key, json.dumps(body, indent=2), {'contentType': 'application/json'})

  def get(self, key: str, options: Optional[dict] = None) -> str:
    try:
      get_object_params = {'Bucket': self.bucket_name, 'Key': key}
      if options:
        start_byte = options.get('startByte', 0)
        end_byte = options.get('endByte', '')
        get_object_params['Range'] = f'bytes={start_byte}-{end_byte}'
      response = self.s3_client.get_object(**get_object_params)
      return response['Body'].read().decode('utf-8')
    except ClientError as e:
      if e.response['Error']['Code'] == 'NoSuchKey':
        raise Exception(f'Object does not exist (key={key}).')
      raise e
    
class SimClient:
  def __init__(self, handle: str):
    self.handle = handle
    self.caller = os.getenv("WING_SIMULATOR_CALLER")
    if not self.caller:
      raise Exception("Environment variable WING_SIMULATOR_CALLER not set.")
    self.hostname = os.getenv("WING_SIMULATOR_URL")
    if not self.hostname:
      raise Exception("Environment variable WING_SIMULATOR_URL not set.")
  
  def make_request(self, method: str, args: List):
    url = f"{self.hostname}/v1/call"
    headers = {
      "Content-Type": "application/json",
    }
    data = {
      "args": args,
      "method": method,
      "caller": self.caller,
      "handle": self.handle
    }

    print(f"Making request to {url} with {data}")
    response = requests.request("POST", url, headers=headers, json=data)

    res = response.json()
    if res.get("error"):
      error = res.get("error")
      message = error["message"] if error.get("message") else ""
      name = error["name"] if error.get("name") else ""
      stack = error["stack"] if error.get("stack") else ""
      raise Exception(f"{name}: {message} \n {stack}")

    return res.get("result")
    
class BucketClient_sim (SimClient):
  def exists(self, key: str) -> bool:
    result = self.make_request("exists", [key])
    return result

  def put(self, key: str, body: str, opts: Optional[dict] = None):
    self.make_request("put", [key, body, opts])
  
  def put_json(self, key: str, body: dict):
    self.make_request("put_json", [key, body, {'contentType': 'application/json'}])

  def get(self, key: str, options: Optional[dict] = None) -> str:
    result = self.make_request("get", [key, options])
    return result
    
def lifted(id: str):
  envValue = os.getenv(f"WING_CLIENTS")
  if envValue:
    jsonValue = json.loads(envValue)
    if id in jsonValue:
      idValue = jsonValue[id]
      if idValue["type"] == "cloud.Bucket":
        target = idValue["target"]
        if target == "aws":
          return BucketClient_aws(idValue["bucketName"])
        elif target == "sim":
          return BucketClient_sim(idValue["handle"])
      
  raise Exception(f"Client not found (id={id}).")