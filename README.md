# Winglibs

Welcome! You've arrived to the warm and cozy home of the *Wing Trusted Library Ecosystem*.

This repository hosts the code for [Wing](https://winglang.io) libraries that we consider trusted
and that meet our community's quality bar.

One of the cool things about trusted libraries is that we take care of building, testing and
publishing them for you.

## How do I add a library?

It's so damn easy.

Clone this repository:

```sh
git clone git@github.com:winglang/winglibs
```

Use the fabulous `mklib.sh` script to scaffold your library:

```sh
./mklib.sh my-awesome-lib
```

This will create a subdirectory called `my-awesome-lib` with some initial source code and a test. It
will also create a github workflow which will take care of building, testing and publishing your
library to npm.

Now do your magic.

When you are ready, submit a pull request to this repository. Someone from the team will review it
and will hopefully provide you with useful feedback and a lot of love, and eventually merge it into
`main`, and your library will be live.

To consume these libraries, users just need to:

```sh
npm i @winglibs/my-awesome-lib
```

And then:

```js
bring my-awesome-lib
```

## License

This repository is licensed under the [MIT License](./LICENSE), unless otherwise specified in a
library directory.