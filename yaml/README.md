# yaml

A Wing library for working with yaml.

## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/yaml
```

## Usage

```js
bring fs;
bring yaml;
bring cloud;

let file = fs.readFile("./test.yml");
let value = yaml.parseValue(file);
yaml.stringifyValue(json);

new cloud.Function(inflight () => {
  let value = yaml.parse(file);
  yaml.stringify(json);
});
```

## License

This library is licensed under the [MIT License](./LICENSE).
