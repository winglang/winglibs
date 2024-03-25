# cognito

A wing library to work with AWS Cognito.

## Prerequisites

* [winglang](https://winglang.io).

## Installation

`sh
npm i @winglibs/cognito
`

## Usage

```js
bring cognito;

let api = new cloud.Api();
api.get("/hello", inflight (req) => {
  return  {
    status: 200
  };
});

let auth = new cognito.Cognito(api);
auth.get("/hello");
```

## Test

### Wing Code

```js
auth.signUp("fakeId@monada.co", "This-is-my-test-99!");
auth.adminConfirmUser("fakeId@monada.co");
let token = auth.initiateAuth("fakeId@monada.co", "This-is-my-test-99!");
let res = http.get("{api.url}/hello", headers: {
  "Authorization": "Bearer {token}"
});
expect.equal(res.status, 200);
```

### AWS CLI

Create a user

```sh
aws cognito-idp sign-up \
 --client-id ${USER_POOL_CLIENT_ID} \
 --username eyalk@monada.co \
 --password NicePassw0rd! \
 --user-attributes Name=name,Value=ekeren Name=email,Value=eyalk@monada.co
```

Get a token for the user (make sure user is confirmed)

```sh
aws cognito-idp initiate-auth \
 --client-id ${USER_POOL_CLIENT_ID} \
 --auth-flow USER_PASSWORD_AUTH \
 --auth-parameters USERNAME=eyalk@monada.co,PASSWORD=NicePassw0rd! \
 --query 'AuthenticationResult.IdToken' \
 --output text
```

Send a request

```sh
curl -H "Authorization: ${TOKEN}" https://5b0y949eik.execute-api.us-east-1.amazonaws.com/prod/hello
```

## License

This library is licensed under the [MIT License](./LICENSE).
