# ssm

A Wing library for working with [Systems Manager](https://aws.amazon.com/systems-manager/).

## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/ssm
```

## Usage

```js
bring expect;
bring ssm;

// create a new parameter
let param = new ssm.Parameter(name: "/test/param1", value: "value1");

// or reference an existing one
let paramRef = new ssm.ParameterRef(arn: "arn:aws:ssm:us-east-1:112233445566:parameter/param-name");

test "get parameter value" {
  expect.equal(param.value(), "value1");
  expect.equal(paramRef.value(), "my-value");
}
```

## License

This library is licensed under the [MIT License](./LICENSE).
