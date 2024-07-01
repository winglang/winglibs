# momento

## Prerequisites

* [winglang](https://winglang.io)
* [Momento](https://www.gomomento.com/) account and API key (see [Getting started with Momento](https://docs.momentohq.com/cache/getting-started))

## Installation

```sh
npm i @winglibs/momento
```

## Usage

```js
bring momento;

let cache = new momento.Cache();

new cloud.Function(inflight () => {
  cache.set("key", "value");
  log(cache.get("key"));
});
```

To deploy an application with Momento resources using Terraform, you will need to set the MOMENTO_AUTH_TOKEN environment variable to a valid super-user API key.
This token will be used to create, update, and delete the cache resources with Terraform, and to create fine-grained access tokens for use at runtime.

## License

This library is licensed under the [MIT License](./LICENSE).
