# sns

This library allows you to interact with the AWS SNS Service.

## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/sns
```

## Usage

```js
bring sns;

let client = new sns.MobileClient();

test "sending an SMS" {
  client.publish(PhoneNumber: "+14155552671", Message: "Hello");
}
```

## License

This library is licensed under the [MIT License](./LICENSE).
