# python

A Wing library for running Python code in inflight.

## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/python
```

## Usage

```js
bring python;

let func = new cloud.Function(new python.InflightFunctionHandler(
  path: "./test-assets",
  handler: "main.handler"
).lift("bucket", bucket, allow: ["get", "put"]));

test "invokes the function" {
  let res = func.invoke();
}
```

It is also possible to interact with Wing resources through the python code

```js
// main.w
let bucket = new cloud.Bucket();
let func = new cloud.Function(new python.InflightFunctionHandler(
  path: "./test-assets",
  handler: "main.handler"
).lift("bucket", bucket, allow: ["get", "put"]));

func.liftClient("bucket", bucket, ["get", "put"]);
```

```python
# main.py
from wing import *

def handler(event, context):
  client = lifted("bucket")
  client.put("test.txt", "Hello, world!")
  
  return {
    "statusCode": 200,
    "body": "Hello!"
  }
```

#### Supported Wing Resource:
* `cloud.Bucket`: `get`, `put`

## License

This library is licensed under the [MIT License](./LICENSE).
