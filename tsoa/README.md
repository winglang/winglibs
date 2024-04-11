# tsoa

A Wing library for working with [TSOA](https://tsoa-community.github.io/docs/) - An OpenAPI-compliant Web APIs using TypeScript.

## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/tsoa
```

## Usage

```js
// main.w
bring tsoa;

let service = new tsoa.Service(
  controllerPathGlobs: ["./src/*Controller.ts"],
  outputDirectory: "../build",
  routesDir: "../build"
);
```

It is also possible to use Wing resources from the TS code

```js
let bucket = new cloud.Bucket();
service.lift(bucket, id: "bucket", allow: ["put"]);
```

```ts
// someController.ts ...
import { lifted } from "@winglibs/tsoa/clients.js";

@Get("{userId}")
public async getUser(
  @Path() userId: number,
  @Request() request: Req,
  @Query() name?: string,
): Promise<User> {
  let bucket = lifted("bucket");
  await bucket.put(userId.toString(), name ?? "not-a-name");

  return  {
    id :userId,
    name: name ?? "not-a-name",
    status: "Happy",
    email:"email",
    phoneNumbers: ["a"]
  }
}
```

## Roadmap

- [x] Support `sim` platform
- [ ] Add Console support for http client (depends on https://github.com/winglang/wing/issues/6131) 
- [x] Support `tf-aws` platform using [Amazon Api Gateway](https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html)
- [ ] Support `gcp` platform using [GCP Api Gateway](https://cloud.google.com/api-gateway)

## License

This library is licensed under the [MIT License](./LICENSE).
