# Terraform Utilities

This Wing library includes some useful utilities to work with Terraform.

## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/tf
```

## `tf.Resource`

Represents an arbitrary Terraform resource.

> `tf.Resource` can only be used when compiling your Wing program to a `tf-*` target.

It takes a `type` and `attributes` properties:

```js
bring tf;

let role = new tf.Resource({
  type: "aws_iam_role",
  attributes: {
    inline_policy: {
      name: "lambda-invoke",
      policy: Json.stringify({
        Version: "2012-10-17",
        Statement: [ 
          { 
            Effect: "Allow",
            Action: [ "lambda:InvokeFunction" ],
            Resource: "*" 
          }
        ]
      })
    },
    assume_role_policy: Json.stringify({
      Version: "2012-10-17",
      Statement: [
        { 
          Action: "sts:AssumeRole",
          Effect: "Allow",
          Principal: { Service: "states.amazonaws.com" }
        },
      ]
    })
  }
}) as "my_role";

let arn = role.getStringAttribute("arn");

test "print arn" {
  log(arn);
}
```

Now, we can compile this to Terraform:

```sh
wing compile -t tf-aws
```

And the output will be:

```json
{
  "resource": {
    "aws_iam_role": {
      "my_role": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/my_role",
            "uniqueId": "my_role"
          }
        },
        "assume_role_policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"states.amazonaws.com\"}}]}",
        "inline_policy": {
          "name": "lambda-invoke",
          "policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"lambda:InvokeFunction\"],\"Resource\":\"*\"}]}"
        }
      }
    }
  },
  "provider": { "aws": [ { } ] },
  "terraform": {
    "backend": {
      "local": {
        "path": "./terraform.tfstate"
      }
    },
    "required_providers": {
      "aws": {
        "source": "aws",
        "version": "5.31.0"
      }
    }
  }
}
```

## `tf.Provider`

Represents an arbitrary Terraform provider.

> `tf.Provider` can only be used when compiling your Wing program to a `tf-*` target.

It takes `name`, `source`, `version`, and `attributes` properties:

```js
bring tf;

new tf.Provider({
  name: "dnsimple",
  source: "dnsimple/dnsimple",
  version: "1.6.0",
  attributes: {
    token: "dnsimple_token",
  }
}) as "DnsimpleProvider";
```

Now, we can compile this to Terraform:

```sh
wing compile -t tf-aws
```

And the output will be:

```json
{
  "provider": {
    "aws": [{}],
    "dnsimple": [
      {
        "token": "dnsimple_token"
      }
    ]
  },
  "terraform": {
    "backend": {
      "local": {
        "path": "./terraform.tfstate"
      }
    },
    "required_providers": {
      "aws": {
        "source": "aws",
        "version": "5.31.0"
      },
      "dnsimple": {
        "source": "dnsimple/dnsimple",
        "version": "1.6.0"
      }
    }
  }
}
```

You can create a singleton provider like so:

```js
class DnsimpleProvider {
  pub static getOrCreate(scope: std.IResource): tf.Provider {
    let root = nodeof(scope).root;
    let singletonKey = "WingDnsimpleProvider";
    let existing = nodeof(root).tryFindChild(singletonKey);
    if existing? {
      return unsafeCast(existing);
    }

    return new tf.Provider(
      name: "dnsimple",
      source: "dnsimple/dnsimple",
      version: "1.6.0",
    ) as singletonKey in root;
  }
}
```

Use `DnsimpleProvider.getOrCreate(scope)` to get the provider instance.

## Maintainers

* [Elad Ben-Israel](@eladb)

## License

This library is licensed under the [MIT License](./LICENSE).
