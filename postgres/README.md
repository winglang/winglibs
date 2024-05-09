# postgres

This library allows using postgres with Wing.

## Prerequisites

* [winglang](https://winglang.io)
* [Neon](https://neon.tech/) free-tier account (for deploying on AWS)

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

You can find connection information in `db.connection`:

- `host` - the host to connect to
- `port` - the external port to use (a token that will resolve at runtime)
- `user` - user name
- `password` - password
- `database` - the database name
- `ssl` - use SSL or not

## `sim`

When executed in the Wing Simulator, postgres is run within a local Docker container.

### Connecting to Postgres from `sim.Container`

If you are connecting from a `sim.Container`, you should use `host.docker.internal` as the `host` in
order to be able to access the host network:

Example:

```js
new sim.Container(
  // ...
  env: {
    DB_HOST: "host.docker.internal",
    DB_PORT: db.connection.port
  }
)
```

### Reference Existing Postgres Database
If you want to import a reference to an existing postgres database, you can use the `DatabaseRef` class:

```js
bring postgres;

let db = new postgres.DatabaseRef() as "somedatabase";


new cloud.Function(inflight() => {
  let users = db.query("select * from users");
});
```
This will automatically create a secret resource that is required for the database connection. To seed this secret, use the `secrets` subcommand:

```sh
❯ wing secrets main.w
1 secret(s) found

? Enter the secret value for connectionString_somedatabase: [input is hidden] 
```

> When referencing an existing database for the `tf-aws` target you will also need to specify VPC information in your `wing.toml` file (unless your database is publicly accessible). Or you will see an warning like this:
```sh
WARNING: Unless your database is accessible from the public internet, you must provide vpc info under `tf-aws` in your wing.toml file
For more info see: https://www.winglang.io/docs/platforms/tf-aws#parameters
```

## `tf-aws`

On the `tf-aws` target, the postgres database is managed using [Neon](https://neon.tech/), a serverless postgres offering.

Neon has a [free tier](https://neon.tech/docs/introduction/free-tier) that can be used for personal projects and prototyping.

Database credentials are securely stored on AWS Secrets Manager (via `cloud.Secret`).

When you deploy Terraform that uses the `Database` class, you will need to have the NEON_API_KEY environment variable set with an API key.

## Roadmap

- [x] Support `tf-aws` platform using Neon
- [ ] Support `sim` platform
- [ ] Make all Neon databases share a Neon project to stay within the free tier
- [ ] Reuse postgres client across multiple queries by requiring users to call `connect()` / `end()` methods
- [ ] Initialize secret value through `cloud.Secret` APIs - https://github.com/winglang/wing/issues/2726
- [ ] Support [parameterized queries](https://node-postgres.com/features/queries#parameterized-query) for preventing SQL injection
- [ ] Customize [type parser](https://node-postgres.com/features/queries#types) for most popular postgres types / conversions to Wing types
- [ ] Have `query()` return both rows and a list of field names
- [ ] More unit tests and examples

## License

Licensed under the [MIT License](../LICENSE).
