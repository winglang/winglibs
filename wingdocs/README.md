# wingdocs

A markdown-based documentation system. Unsurprisingly, great for stuff like [the Wing Documentation](https://winglang.io/docs).

## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/wingdocs
```

## Usage

Create `main.w`:

```js
bring wingdocs;

new wingdocs.Site(
  source: "{@dirname}/docs", // location of your docs markdown tree
  title: "Dokidokidocs",
  // more configuration coming soon...
);
```

Create `docs/index.md`:

```md
Hello, I am your docs!
```

Run in the simulator:

```sh
wing it
```

Deploy to AWS (via CloudFront):

```sh
wing compile -t tf-aws
cd target/main.tfaws
terraform init
terraform apply
```

(You'll need AWS credentials)

## Roadmap

- Blog
- Additional sections ("contributing")
- Winglibs documentation (with API docs)
- Patterns
- Playground
- Multi-language
- Learn (guided tutorials)
- Patterns


## License

This library is licensed under the [MIT License](./LICENSE).
