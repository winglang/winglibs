bring cloud;
bring expect;
bring "./lib.w" as l;

let email = new l.Email(sender: "example@example.com");

test "send email" {
  // sending an email with html
  email.send(
    to: ["example@example.com"],
    subject: "My subject",
    text: "My body",
    html: "<h1>My body</h1>",
  );

  // sending an email without html
  email.send(
    to: ["example@example.com"],
    subject: "My subject",
    text: "My body",
  );
}
