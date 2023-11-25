# vite

## Prerequisites

- [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/vite
```

## Usage

```js
bring vite;

let website = new vite.Vite(
  // The path to the website root.
  root: "../website",

  // (optional) Environment variables.
  env: {
    VITE_API_URL: "https://api.example.com",
  },

  // (optional) Whether to generate type definitions for the environment variables.
  generateTypeDefinitions: false,

  // (optional) How long to cache the files for (assets will be cached forever regardless of this value)
  cacheDuration: 5min,
);

// Get the URL of the website.
let url = website.url;
```

- For the `sim` target, the Vite resource will start the Vite dev server. The `url` property will be the URL of the dev server
- For the `tf-aws` target, the Vite resource will build the website files and upload them using the `cloud.Website` resource. It will cache the files in `/assets/*` forever, and will cache the rest of the files for `5min` by default. The `url` property will be the URL of the website

## License

This library is licensed under the [MIT License](./LICENSE).
