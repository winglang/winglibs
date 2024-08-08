/// Represents a Stripe Event
pub struct StripeEvent {
  id: str;  
  type: str;
  api_verison: str?;
  created: num;
  data: Json;
}
