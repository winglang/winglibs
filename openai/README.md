# openai

## Prerequisites

* [winglang](https://winglang.io).

## Installation

`sh
npm i @winglibs/openai
`

## Example

`js
bring openai;

let openAIService = new openai.OpenAI("your-api-key");

new cloud.Function(inflight () => {
  let joke = openAIService.createCompletion("tell me a short joke");
  log(joke);
});
`

## Usage
The `openai.OpenAI` resource provides the following inflight methods:

* `createCompletion` - Gets an answer to a prompt.

The preflight constructor requires an api key in the form of either a secret or a string.

## Roadmap

* [x] Support the rest of the openai API
* [ ] Add more examples
* [ ] Add more tests

## Maintainers

* [Shai Ber](https://github.com/shaiber)

## License

Licensed under the [MIT License](/LICENSE).
