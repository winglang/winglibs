bring cloud;
bring "./lib.w" as ses;

let emailService = new ses.EmailService(emailIdentities: ["bot@wing.cloud"]);

test "sends an email" {
  assert(emailService.sendEmail(Source: "bot@wing.cloud", Destination: {
    ToAddresses: ["bot@wing.cloud"]
  }, Message: {
    Subject: {
      Data: "Hello, World!"
    },
    Body: {
      Text: {
        Data: "Hello, World!!!"
      }
    }
  }) != nil);
}
