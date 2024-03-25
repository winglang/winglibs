# openai

An [OpenAI](https://openai.com) library for Winglang.

> This is an initial version of this library which currently exposes a very small subset of the
> OpenAI API.

## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/openai
```

## Example

```js
bring cloud;
bring openai;

let key = new cloud.Secret(name: "OAIApiKey");
let oai = new openai.OpenAI(apiKeySecret: key);

new cloud.Function(inflight () => {
  let joke = oai.createCompletion("tell me a short joke", model: "gpt-3.5-turbo", max_tokens: 2048);
  log(joke);
});
```

When running in a `test` context, the `createCompletion` method will return a JSON object which
echos the request under the `mock` key:

```js
bring expect;

test "create completion test" {
  let r = oai.createCompletion("tell me a short joke");
  expect.equal(r, Json.stringify({
    mock: {
      prompt:"tell me a short joke",
      params:{"model":"gpt-3.5-turbo","max_tokens":2048}
    }
  }));
}
```

## Usage

```js
new openai.OpenAI();
```

* `apiKeySecret` - a `cloud.Secret` with the OpenAI API key (required).
* `orgSecret` - a `cloud.Secret` with the OpenAI organization ID (not required).

You can also specify clear text values through `apiKey` and `org`, but make sure not to commit these
values to a repository :warning:.

Methods:

* `inflight createCompletion()` - requests a completion from a model. Options are `model` (defaults
  to `gpt-3.5.turbo`) and `max_tokens` (defaults to 2048).

## Roadmap

* [ ] Support the rest of the OpenAI API
* [ ] Add more examples
* [ ] Add more tests

## Maintainers

* [Shai Ber](https://github.com/shaiber)

## License

Licensed under the [MIT License](/LICENSE).
