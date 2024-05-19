bring "./lib.w" as sns;

let client = new sns.MobileClient();

test "will send an SMS" {
  client.publish(PhoneNumber: "+14155552671", Message: "Hello");
}
