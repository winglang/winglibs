# sagemaker

## Prerequisites

- [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/sagemaker
```

## Usage

The library enables owners of a trained sagemaker model, to access its Endpoints from a winglang inflight code.

```wing
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

## Troubleshooting

Encountering issues? Here are some common problems and their solutions:

### `Error: Region is missing`

**Problem**: When trying to invoke the sagemaker model, the region reports missing
`Error: Region is missing`

**Solution**:

Add `AWS_REGION` to the cloud.Function environment variable:

```wing
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

new cloud.Function(handler, env: {
  "AWS_REGION":"us-west-2"
});
```


## License

This library is licensed under the [MIT License](./LICENSE).
