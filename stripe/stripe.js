exports.verifyEvent = async ({ data: request, secretKey, webhookSecret}) => {

    const stripe = require('stripe')(secretKey);
    const endpointSecret = webhookSecret;
    const sig = request.headers['stripe-signature'];

    if(process.env.IGNORE_STRIPE_WEBHOOK_VALIDATION === 'true') return true;

    try {
      stripe.webhooks.constructEvent(request.body, sig, endpointSecret);
      return true;
    }
    catch (err) {
      console.log('Event is not valid', err.message);
      return false;
    }
  };
  