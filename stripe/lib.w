bring util;
bring cloud;
bring "./types.w" as types;

/// Properties for Stripe webhook
pub struct Props {
  /// The secret key for Stripe as a string
  secretKey: str?;
  /// Secret key for Stripe as a Secret resource (recommended)
  secretKeySecret: cloud.Secret?;

  // The secret key for the Stripe webhook as a string
  webhookKey: str?;
  /// Secret key for the Stripe webhook (recommended)
  webhookKeySecret: cloud.Secret?;

  /// Configure DLQ for the API
  configureDQL: bool?;
}

struct VerifyEventOptions {
    data: cloud.ApiRequest;
    secretKey: str;
    webhookSecret: str;
}

class Stripe {
    // TODO: Not sure the keys should be passed in like this?
    pub extern "./stripe.js" static inflight verifyEvent(options: VerifyEventOptions): bool;
}

pub class Webhook {
  pub api: cloud.Api;
  eventHandlers: MutMap<inflight(Json):Json?>;

  queue: cloud.Queue;

  /// The secret for stripe SDK
  secretKey: str?;
  secretKeySecret: cloud.Secret?;

  /// The secret key for the webhook
  webhookKey: str?;
  webhookKeySecret: cloud.Secret?;

  new (props: Props){

    this.eventHandlers = MutMap<inflight (Json): Json?>{};
    this.secretKey = props.secretKey;
    this.secretKeySecret = props.secretKeySecret;
    this.webhookKey = props.webhookKey;
    this.webhookKeySecret = props.webhookKeySecret;
    this.api = new cloud.Api() as "API";


    // Create the webhook for stripe
    this.createWebhookEndpoint();

    // Store events in queue for processing
    this.queue = new cloud.Queue({ dlq: { queue: new cloud.Queue() as "DLQ" }}) as "Webhook queue";

    // Configure the consumer
    this.queue.setConsumer(inflight (message: str) => {
        log("PROCESS EVEN!");
        this.processEvent(message);
    });

    nodeof(this).icon = "banknotes";
    nodeof(this).color = "lime";
  
  }

  /// process message from the queue
  inflight processEvent(message: str) {
    let event = types.StripeEvent.parseJson(message);
    log(event.type);
    if let handler = this.eventHandlers.tryGet(event.type) {
        log("FOUND HANDLER");
        handler(event);
    } else {
        log("recevied event for {event.type}, but no listeners found. Ignoring it.");
    }
  }

  createWebhookEndpoint() {


    this.api.post("/webhook", inflight (request: cloud.ApiRequest): cloud.ApiResponse => {

        if let body = request.body {

            let UNDEFINED = "<UNDEFINED>";
            // IF the Secrets are defined by resource get them, fallback to string values.
            let secretKey = this.secretKeySecret?.value() ?? this.secretKey ?? UNDEFINED;
            let webhookSecret = this.webhookKeySecret?.value() ?? this.webhookKey ?? UNDEFINED;

            let data = Json.parse(body);

            // Should we verify the event? Pass an option into this.

            // Verify the event is valid with the Stripe extern
            let isValidEvent = Stripe.verifyEvent({ data: request, secretKey: secretKey, webhookSecret: webhookSecret});

            if isValidEvent {
                // Add  items to the queue
                this.queue.push(body);
                return cloud.ApiResponse {
                    status: 202,
                };
            } else {
                return cloud.ApiResponse { status: 404 };
            }
        }
    }, { env: {
      IGNORE_STRIPE_WEBHOOK_VALIDATION: util.env("IGNORE_STRIPE_WEBHOOK_VALIDATION")
    }});
  }

   /// Register an event listener
   ///  - *eventName* - The stripe event name to subscribe to
   /// - *handler* - The inflight to call when the event is received
  pub onEvent(eventName: str, handler: inflight(Json): Json?) {
    this.eventHandlers.set(eventName, handler);
  }
  
}