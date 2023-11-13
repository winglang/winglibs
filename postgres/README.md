# postgres

This library allows using postgres with Wing.

## Installation

Use `npm` to install this library:

```sh
npm i @winglibs/postgres
```

## Bring it

```js
bring cloud;
bring postgres;

let db = new postgres.Database(
  name: "mydb",
  pgVersion: 15,
);

let api = new cloud.Api();
api.get("/users", inflight (req) => {
  let users = db.query("select * from users");
  return {
    status: 200,
    body: Json.stringify(users),
  };
});
```

## `sim`

When executed in the Wing Simulator, postgres is run within a local Docker container.

## `tf-aws`

On the `tf-aws` target, the postgres database is managed using [Neon](https://neon.tech/), a serverless postgres offering.

Neon has a [free tier](https://neon.tech/docs/introduction/free-tier) that can be used for personal projects and prototyping.

Database credentials are securely stored on AWS Secrets Manager (via `cloud.Secret`).

When you deploy Terraform that uses the `Database` class, you will need to have the NEON_API_KEY environment variable set with an API key.

## Roadmap

- [x] Support `tf-aws` platform using Neon
- [ ] Support `sim` platform
- [ ] Make all Neon databases share a Neon project to stay within the free tier
- [ ] Initialize secret value only `cloud.Secret` APIs
- [ ] Support [parameterized queries](https://node-postgres.com/features/queries#parameterized-query) for preventing SQL injection
- [ ] Customize [type parser](https://node-postgres.com/features/queries#types) for most popular postgres types / conversions to Wing types
- [ ] Have `query()` return both rows and a list of field names
- [ ] More unit tests and examples

## License

Licensed under the [MIT License](../LICENSE).
