bring expect;
bring cloud;
bring http;
bring "./lib.w" as Stripe;

let app = new Stripe.Webhook(secretKey: "super-secret-key", webhookKey: "super-secret-key");

// How can I test this!??
app.onEvent("customer.created", inflight (event) => {
  return event;
});


test "app_mention event" {
  let endpoint = app.api.url;

  let stripeEvent = {
    "id": "evt_1PYShZHDPHgalV3DNoBes3PM",
    "object": "event",
    "api_version": "2023-10-16",
    "created": 1720011265,
    "data": {
        "object": {
            "id": "cus_QPHGpm7ooXC4eJ",
            "object": "customer",
            "address": "null",
            "balance": 0,
            "created": 1720011265,
            "currency": "null",
            "default_source": "null",
            "delinquent": false,
            "description": "null",
            "discount": "null",
            "email": "null",
            "invoice_prefix": "B07B9195",
            "invoice_settings": {
                "custom_fields": "null",
                "default_payment_method": "null",
                "footer": "null",
                "rendering_options": "null"
            },
            "livemode": false,
            "metadata": {},
            "name": "4444",
            "phone": "null",
            "preferred_locales": [],
            "shipping": "null",
            "tax_exempt": "none",
            "test_clock": "null"
        }
    },
    "livemode": false,
    "pending_webhooks": 1,
    "request": {
        "id": "req_HyMlRgcRZ7MMri",
        "idempotency_key": "8ccbb61e-92fb-4220-8aab-f77df325ed52"
    },
    "type": "customer.created"
  };

  let res = http.post("{endpoint}/webhook", {
    body: Json.stringify(stripeEvent),
    headers: {
      "Stripe-Signature": "t=1720018938,v1=c7d1c0bda8754d27077ff3cb93119e152f74e85ef74f0c66a8ffe41c3ce77171"
    }
  });

  expect.equal(res.status, 202);

}