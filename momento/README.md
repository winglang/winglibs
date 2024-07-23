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
bring cloud;
bring momento;

let token = new cloud.Secret("momento-key");
let cache = new momento.Cache(token: token);

new cloud.Function(inflight () => {
  cache.set("key", "value");
  log(cache.get("key"));
});
```

To deploy an application with Momento resources using Terraform, you will need to set the MOMENTO_API_KEY environment variable to a valid super-user API key on the machine running `terraform apply`.

You will also need a valid Momento token (super-user token or fine-grained access token) with permissions for performing any data operations on the cache(s) that can be used by the application.
You can set the secret by running `wing secrets -t tf-aws main.w`.
You are responsible for rotating the secret as needed.

See the [Momento documentation](https://docs.momentohq.com/cache/develop/authentication/api-keys) for more information about creating API keys.

## License

This library is licensed under the [MIT License](./LICENSE).
