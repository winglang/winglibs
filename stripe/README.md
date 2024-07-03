# Stripe

An [Stripe](https://stripe.com) library for Winglang.

> This is an initial version of this library which currently exposes a very small subset of the
> Stripe API.

## Prerequisites

* [winglang](https://winglang.io).
* [Stripe Account](https://stripe.com)
* [Stripe Webhook Secret and Stripe API Secret](https://docs.stripe.com/webhooks)


## Installation

```sh
npm i @winglibs/stripe
```

## Example

```js
bring cloud;
bring "./lib/stripe.w" as Stripe;

let stripeSecretKey = new cloud.Secret(name: "STRIPE_API_TOKEN") as "Stripe Secret";
let webhookSecret = new cloud.Secret(name: "STRIPE_ENDPOINT_SECRET") as "Webhook Secret";
let stripe = new Stripe.Webhook({ webhookSecret: webhookSecret, secretKey: stripeSecretKey }) as "Stripe integration";

// Listen to any stripe event
stripe.onEvent("customer.created", inflight (ctx, event) => {
  // New customer event triggered
  log("Event: {event["type"]}");
});

```

## Usage

```js
new Stripe.Webhook();
```

* `webhookKeySecret` -  a `cloud.Secret` with the Stripe webhook secret (required)
* `secretKeySecret` - a `cloud.Secret` with the Stripe secret key (required)

You can also specify clear text values through `webhookKey` and `secretKey`, but make sure not to commit these values to a repository :warning:.

`Webhook()` creates an [API cloud resource](https://www.winglang.io/docs/standard-library/cloud/api) with a `/webhook` endpoint, [Queue](https://www.winglang.io/docs/standard-library/cloud/queue) (with a configured Dead-letter queue) and [Function resource](https://www.winglang.io/docs/standard-library/cloud/function) to handle the registered events.

The `/webhook` receives events from Stripe. The event is verified through HTTP signatures.

The event is then put onto a Queue. 

Messages on the queue are then processed by a Function. This function then calls your registered functions.

If messages cannot be processed they are put on the configured DLQ.

Methods:

* `inflight onEvent()` - Register a listener for an event on the API.

### Running locally

Create an .env file in your Wing project and add these values.

```sh
STRIPE_API_TOKEN={API_TOKEN}
STRIPE_ENDPOINT_SECRET={WEBHOOK_API_TOKEN}
```

When running the [Wing Cloud Simulator](https://www.winglang.io/docs/platforms/sim) the secrets are used from the `.env` file.

With the Wing console you can also expose your generated URL using Wing tunnels. This can be valuable for testing your Stripe integrations.

## Roadmap

* [ ] Support the rest of the Stripe API
* [ ] Add more examples
* [ ] Add more tests

## Maintainers

* [David Boyne](https://github.com/boyney123)

## License

Licensed under the [MIT License](/LICENSE).
