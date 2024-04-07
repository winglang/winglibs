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
service.liftClient("bucket", bucket, ["put"]);
```

```ts
// someController.ts ...
@Get("{userId}")
public async getUser(
  @Path() userId: number,
  @Request() request: Req,
  @Query() name?: string,
): Promise<User> {
  let bucket = getClient(request, "bucket");
  bucket.put(userId.toString(), name ?? "not-a-name");

  return  {
    id :userId,
    name: name ?? "not-a-name",
    status: "Happy",
    email:"email",
    phoneNumbers: ["a"]
  }
}
```

## License

This library is licensed under the [MIT License](./LICENSE).
