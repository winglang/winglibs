import requests
import boto3
from botocore.exceptions import ClientError
import json
from typing import Optional, List, TypedDict, Any
import os
import random

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

class Credentials(TypedDict):
  accessKeyId: str
  secretAccessKey: str

class ClientConfig(TypedDict):
  region: str
  endpoint: str
  credentials: Credentials

class Connection(TypedDict):
  tableName: str
  clientConfig: ClientConfig

class DynamodbTableClient_base:
  def __init__(self, connection: Connection, resource: boto3.resource = None):
    self.table_name = connection["tableName"]
    self.connection = connection
    self.resource = resource or boto3.resource('dynamodb')
    self.table = self.resource.Table(self.table_name)

  def get(self, **kwargs):
    return self.table.get_item(**kwargs)

  def put(self, **kwargs):
    return self.table.put_item(**kwargs)
  
  def read_write_connection(self):
    return self.connection

class DynamodbTableClient_aws(DynamodbTableClient_base):
  def __init__(self, props: dict):
    connection: Connection = props["connection"]
    super().__init__(connection, boto3.resource('dynamodb'))
  
class DynamodbTableClient_sim(DynamodbTableClient_base):
  def __init__(self, props: dict):
    connection: Connection = props["connection"]
    super().__init__(connection, boto3.resource(
      'dynamodb', 
      region_name=connection["clientConfig"]["region"],
      endpoint_url=connection["clientConfig"]["endpoint"],
      aws_access_key_id=connection["clientConfig"]["credentials"]["accessKeyId"],
      aws_secret_access_key=connection["clientConfig"]["credentials"]["secretAccessKey"],
    ))

class SNSMobileClient_sim:
  def __init__(self, store: BucketClient_sim):
    self.store = store

  def publish(self, **kwargs):
    id = str(random.randint(10000000, 99999999))
    self.store.put(id, json.dumps(kwargs));
    return {
      "MessageId": id,
    }
  
class SNSMobileClient_aws:
  def __init__(self, client: boto3.client = None):
    self.client = client or boto3.client('sns')

  def publish(self, **kwargs):
    return self.client.publish(**kwargs)
  
class SESEmailService_sim:
  def __init__(self, store: BucketClient_sim):
    self.store = store

  def send_email(self, **kwargs):
    id = str(random.randint(10000000, 99999999))
    self.store.put(id, json.dumps(kwargs));
    return id
  
  def send_raw_email(self, **kwargs):
    id = str(random.randint(10000000, 99999999))
    self.store.put(id, json.dumps(kwargs));
    return id
  
class SESEmailService_aws:
  def __init__(self, client: boto3.client = None):
    self.client = client or boto3.client('ses')

  def send_email(self, **kwargs):
    return self.client.send_email(**kwargs)
  
  def send_raw_email(self, **kwargs):
    return self.client.send_raw_email(**kwargs)

def try_lifted(id: str):
  try:
    return lifted(id)
  except Exception as e:
    return None

def lifted(id: str):
  envValue = os.getenv(f"WING_CLIENTS")
  if envValue:
    jsonValue = json.loads(envValue)
    if id in jsonValue:
      return create_client(jsonValue[id])
      
  raise Exception(f"Client not found (id={id}).")

def create_client(idValue: dict):
  target = idValue["target"]
  if idValue["type"] == "cloud.Bucket":
    if target == "aws":
      return BucketClient_aws(idValue["bucketName"])
    elif target == "sim":
      return BucketClient_sim(idValue["handle"])
  if idValue["type"] == "@winglibs.dyanmodb.Table":
    if target == "aws":
      return DynamodbTableClient_aws(idValue["props"])
    elif target == "sim":
      return DynamodbTableClient_sim(idValue["props"])
  if idValue["type"] == "@winglibs.sns.MobileClient":
    if target == "aws":
      return SNSMobileClient_aws(idValue["props"])
    elif target == "sim":
      return SNSMobileClient_sim(create_client(idValue["children"]["store"]))
  if idValue["type"] == "@winglibs.ses.EmailService":
    if target == "aws":
      return SESEmailService_aws(idValue["props"])
    elif target == "sim":
      return SESEmailService_sim(create_client(idValue["children"]["store"]))
        
def from_function_event(event):
  target = os.getenv(f"WING_TARGET")
  if target == "tf-aws":
    return str(event)
  elif target == "sim":
    payload = event["payload"]
    return payload if isinstance(payload, str) else json.dumps(payload)
  else:
    raise Exception(f"Unsupported target: {target}")
  
def from_topic_event(event):
  target = os.getenv(f"WING_TARGET")
  if target == "tf-aws":
    return [event["Records"][0]["Sns"]["Message"]]
  elif target == "sim":
    return [str(event["payload"])]
  else:
    raise Exception(f"Unsupported target: {target}")
  
def from_queue_event(event):
  target = os.getenv(f"WING_TARGET")
  if target == "tf-aws":
    return [event["Records"][0]["body"]]
  elif target == "sim":
    return [str(event["payload"])]
  else:
    raise Exception(f"Unsupported target: {target}")
  
class BucketEvent:
  key: str
  type: str

def from_bucket_event(event):
  target = os.getenv(f"WING_TARGET")
  if target == "tf-aws":
    bucket_event = BucketEvent()
    data = json.loads(event["Records"][0]["Sns"]["Message"])
    key = data["Records"][0]["s3"]["object"]["key"]
    bucket_event.key = key
    bucket_event.type = os.getenv("WING_BUCKET_EVENT")
    return [bucket_event]
  elif target == "sim":
    data = event["payload"]
    bucket_event = BucketEvent()
    bucket_event.key = data["key"]
    bucket_event.type = data["type"]
    return [bucket_event]
  else:
    raise Exception(f"Unsupported target: {target}")

class ApiRequest(TypedDict):
  method: str
  path: str
  query: dict
  headers: dict
  body: str
  vars: dict

def from_api_event(event):
  target = os.getenv(f"WING_TARGET")
  if target == "tf-aws":
    req: ApiRequest = {
      'method': event["httpMethod"],
      'path': event["path"],
      'query': event["queryStringParameters"],
      'headers': event["headers"],
      'body': event["body"],
      'vars': event["pathParameters"]
    }
    return req
  elif target == "sim":
    data = event["payload"]
    req: ApiRequest = {
      'method': data["method"],
      'path': data["path"],
      'query': data["query"],
      'headers': data["headers"],
      'body': data["body"],
      'vars': data["vars"]
    }
    return req
  else:
    raise Exception(f"Unsupported target: {target}")
  
def from_api_response(res = None):
  if not res:
    return {
      "statusCode": 200,
      "body": "",
      "headers": {}
    }

  response = {}
  if not res.get("status"):
    response["statusCode"] = 200
  else:
    response["statusCode"] = res["status"]

  if not res.get("body"):
    response["body"] = ""
  else:
    response["body"] = res["body"]

  if not res.get("headers"):
    response["headers"] = {}
  else:
    response["headers"] = res["headers"]

  return response

class Aws:
  @staticmethod
  def to_aws_api_event(event: dict[str, Any]):
    target = os.getenv(f"WING_TARGET")
    if target == "tf-aws":
      return req
    elif target == "sim":
      data = event["payload"]
      body = data["body"]
      req = {
        'httpMethod': data["method"],
        'path': data["path"],
        'queryStringParameters': data["query"],
        'headers': data["headers"],
        'body': None if body == "" else body,
        'pathParameters': data["vars"],
        'requestContext': {
          'http': {
            'method': data["method"],
            'path': data["path"]
          }
        },
      }
      return req
    else:
      return None