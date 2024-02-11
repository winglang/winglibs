# sagemaker

## Prerequisites

- [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/sagemaker
```

## Usage

The library enables owners of a trained sagemaker model, to access its Endpoints from a winglang inflight code.

```js
bring sagemaker;
bring cloud;

let sm = new sagemaker.Endpoint("my-endpoint-name", "my-inference-name");

let handler = inflight () => {
  let res = sm.invoke({
    inputs: "do AI stuff"
    },
    ContentType: "application/json"
  );
  log(res.Body);
};

new cloud.Function(handler);
```

## License

This library is licensed under the [MIT License](./LICENSE).
