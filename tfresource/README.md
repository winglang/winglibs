# tfresource

A [winglang](https://winglang.io) library for creating custom Terraform resources.

Useful if there is no Terraform provider for a service you wish to provision in your app or if you
want more customization of the control plane.

## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/tfresource
```

## Usage

The `tfresource.TerraformResource` class represents a Terraform resource.

Use the `onXxx` methods to register handlers for the four Terraform lifecycle events:

* `onCreate(handler: inflight (): Json)` - create the resource and return the state to store.
* `onRead(handler: inflight (Json): Json)` - read the live state of the resource given the stored state.
* `onUpdate(handler: inflight (Json): Json)` - update the resource to the given state and return the new state to store.
* `onDelete(handler: inflight (Json): Json?)` - delete the resource given the stored state.

Let's look at an example which implements a `File` resource:

```js
bring tfresource as tfr;
bring fs;
bring util;

struct FileState {
  hash: str;
  path: str;
}

class File {
  new(path: str, data: str) {
    let r = new tfr.TerraformResource();

    r.onCreate(inflight () => {
      fs.writeFile(path, data);
      return this.state(path, data);
    });

    r.onDelete(inflight (state) => {
      let s = FileState.fromJson(state);
      fs.remove(s.path);
    });

    r.onRead(inflight (state) => {
      return this.state(path, data);
    });
  }

  inflight state(path: str, data: str): FileState {
    return {
      hash: util.sha256(data),
      path: path,
    };
  }
}
```

Now, we can use this new resource like this:

```js
new File("hello.txt", "my file") as "hello";
new File("world.txt", "your file") as "world";
```

If we compile this to `tf-*` and apply:

```sh
wing compile -t tf-aws main.w
cd target/main.tfaws
terraform init
terraform apply
```

You'll notice two new files:

```sh
$ cat hello.txt
my file
$ cat world.txt
your file
```

Now, let's change our code to:

```js
new File("hello1.txt", "my file") as "hello";
new File("world.txt", "your file 2") as "world";
```

Notice that we've changed the *name* of the first file and the *contents* of the 2nd file.

Compile and apply:

```sh
wing compile -t tf-aws main.w
cd target/main.tfaws
terraform apply
```

Now, you'll see that `hello.txt` was *renamed* to `hello1.txt` and `world.txt` includes the new
content. How cool is that?

## Maintainers

* [@eladb](https://github.com/eladb)

## License

This library is licensed under the [MIT License](./LICENSE).
