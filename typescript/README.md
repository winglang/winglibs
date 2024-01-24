# TypeScript support for Winglang

> TODO

## Prerequisites

* [winglang](https://winglang.io).

## Installation

`sh
npm i @winglibs/typescript
`

## Usage

The `FunctionHandler`, `QueueHandler` and `ApiEndpointHandler` types can be used to define inflight
handlers from a TypeScript codebase.

For example:

```ts
// src/index.ts
exports.handler = async (event, context) => {
  console.log("Welcome to TypeScript", event);
  return {
    status: 200,
    body: JSON.stringify({ message: "Hello, TypeScript" }),
  };
};
```

```js
// main.w
bring typescript;

new cloud.Function(new typescript.FunctionHandler("./src"));
```

## TODO

- [x] Lift cloud resources into TypeScript
- [ ] Generate .d.ts file with type information for handler (and lifts)
- [ ] Tests
- [ ] Hot reloading
- [ ] Bundling configuration
- [ ] README

Workarounds:

* https://github.com/winglang/wing/issues/5476
* `__dirname` to reference `src`
* `patchToInflight`

## License

This library is licensed under the [MIT License](./LICENSE).
