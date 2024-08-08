bring cloud;
bring "./lib.w" as Stripe;

let secretKeySecret = new cloud.Secret(name: "STRIPE_API_TOKEN") as "Stripe Secret";
let webhookKeySecret = new cloud.Secret(name: "STRIPE_ENDPOINT_SECRET") as "Webhook Secret";
let stripe = new Stripe.Webhook(webhookKeySecret: webhookKeySecret, secretKeySecret: secretKeySecret) as "Stripe integration";

// List of events https://docs.stripe.com/api/events/types
// Make sure you regsiter events in your Stripe Event Destination https://docs.stripe.com/event-destinations
stripe.onEvent("customer.created", inflight (event) => {
  log("Event: {event["type"]}");
});
