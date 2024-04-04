# tsoa

A Wing library for working with [TSOA](https://tsoa-community.github.io/docs/) - An OpenAPI-compliant Web APIs using TypeScript.

## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/tsoa
```

## Usage

```js
bring tsoa;

let service = new tsoa.Service(
  controllerPathGlobs: ["./src/*Controller.ts"],
  outputDirectory: "../build",
  routesDir: "../build"
);
```

## License

This library is licensed under the [MIT License](./LICENSE).
