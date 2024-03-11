# Wing ngrok support 

This library can be used to create an [ngrok](https://ngrok.com) tunnel for local development that
forwards HTTP requests to a localhost endpoint.

When compiled to the cloud, this resource is a no-op.

## Prerequisites

* [winglang](https://winglang.io).
* An [ngrok account](https://ngrok.com).
* `NGROK_AUTHTOKEN` should include the auth token for your ngrok user.

## Installation

```sh
npm i @winglibs/ngrok
```

## Usage

Let's forward all requests that are sent to `eladb.ngrok.dev` to our `cloud.Api`.

```js
bring ngrok;

let api = new cloud.Api();

api.get("/", inflight () => {
  return {
    status: 200,
    body: "hello ngrok!"
  };
});

let t = new ngrok.Tunnel(api.url, 
  domain: "eladb.ngrok.dev",

  // optional callback
  onConnect: inflight (url: str) => {
    log("connected to {url}");
  },
);

// you can add listeners
t.onConnect(inflight (url) => {
  log("url: {url}");
});

new cloud.Function(inflight () => {
  log("tunnel connected to {t.url}");
});
```

Once a tunnel is initialized, if an `onConnect` callback is set, it will be called with the external
URL of the tunnel. You can use this hook, for example, to update a webhook URL with a dynamic ngrok
endpoint.

## Maintainers

- [@eladb](https://github.com/eladb)

## License

This library is licensed under the [MIT License](./LICENSE).
