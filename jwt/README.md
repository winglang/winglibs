# jwt

A Wing library for working with JWT authentication.

## Prerequisites

* [winglang](https://winglang.io).

## Installation

`sh
npm i @winglibs/jwt
`

## Usage

```js
bring util;
bring jwt;

test "will sign and verify" {
  let id = util.nanoid();
  let token = jwt.sign({ foo: id }, "shhhhh");
  let decoded1 = jwt.verify(token, secret: "shhhhh");
}
```

## License

This library is licensed under the [MIT License](./LICENSE).
