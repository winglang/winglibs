# Wing Redis Client Library

This library provides a Wing client for Redis.

## Installation

Use `npm` to install this library:

```sh
npm i @winglibs/wing-redis
```

## Bring it

The `redis.Redis` resource represents a Redis client.

```js
bring wing-redis;

new redis.Redis() as "redis";
```

## `sim`

When executed in the Wing Simulator, the client is started within a local Docker container.

## `tf-aws`

Coming soon.

## Roadmap

* [x] Support for the Wing Simulator
* [ ] Support for AWS
* [ ] Support for GCP
* [ ] Support for Azure

## License

Licensed under the [MIT License](../LICENSE).