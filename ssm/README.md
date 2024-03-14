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

let param = new ssm.Parameter(name: "/test/param1", value: "value1");

test "get parameter value" {
  expect.equal(param.value(), "value1");
}
```

## License

This library is licensed under the [MIT License](./LICENSE).
