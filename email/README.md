# email

## Prerequisites

* [winglang](https://winglang.io).

For AWS, you need to have an AWS account and the AWS CLI installed. You'll also need to have [Terraform](https://developer.hashicorp.com/terraform/install) or [OpenTofu](https://opentofu.org/docs/intro/install/) installed to deploy the application.

## Installation

```sh
npm i @winglibs/email
```

## Usage

```js
bring email;

let email = new email.Email(sender: "example@example.com");

new cloud.Function(inflight () => {
  email.send(
    to: ["example@example.com"],
    subject: "My subject",
    text: "My content",
    html: "<h1>My content</h1>", // optional
  );
});
```

### Simulator

When using `email.Email` in the local simulator, emails are mocked and are emitted to the logs.
A table showing all emails that have been sent can be viewed in the email resource's interaction panel.

### AWS

When compiled to AWS platforms, the email resource uses [Amazon SES](https://aws.amazon.com/ses/).
For testing, we recommend using your own email address for `sender` since sender email addresses must be verified.
When the application is deployed, an email will be sent to verify the configured `sender` address.

By default, new AWS accounts are in the sandbox mode. This means emails can only be sent to verified addresses. It also limits the number of emails that can be sent. To send emails to other addresses, you need to request production access [here](https://docs.aws.amazon.com/ses/latest/dg/request-production-access.html).

## License

This library is licensed under the [MIT License](./LICENSE).
