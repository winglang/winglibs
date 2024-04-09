# python

A Wing library for integrating with Python code.

## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/python
```

## Usage

```js
bring python;

let func = new python.Function(
  path: "./test-assets",
  handler: "main.handler",
);

test "invokes the function" {
  let res = func.invoke();
}
```

It is also possible to interact with Wing resources through the python code

```js
// main.w
let bucket = new cloud.Bucket();
let func = new python.Function(
  path: "./test-assets",
  handler: "main.handler",
);

func.liftClient("bucket", bucket, ["get", "put"]);
```

```python
# main.py
from wing_helper import *

def handler(event, context):
  client = get_client("bucket")
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
