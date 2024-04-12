# React

Use React in your project.

## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/react
```

## Usage

`main.w`:

```js
bring cloud;
bring react;

let api = new cloud.Api(cors: true);

api.get("/", inflight () => {
  return {
    status: 200,
    body: "Hello World! API",
  };
});

let project = new react.App(
  projectPath: "../react-project",
  localPort: 4500,
);

project.addEnvironment("API_URL", api.url);
project.addEnvironment("TEXT", "Hello World!");
```

Add `<script src="./wing.js"></script>` to your `index.html` file:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#000000" />
    <meta
      name="description"
      content="Web site created using create-react-app"
    />
    <script src="./wing.js"></script>
    <title>React App</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root"></div>
  </body>
</html>
```

The variables will be available via `window.wingEnv`:

```jsx
import { useEffect, useState } from "react";

function App() {
  const [text, setText] = useState("");

  const { API_URL, TEXT } = window.wingEnv;

  useEffect(() => {
    fetch(API_URL).then((response) => {
      response.text().then((data) => {
        setText(data);
      })
    });
  }, []);

  return (
    <div className="App">
      <p>TEXT: {TEXT}</p>
      <p>FROM API: {text}</p>
    </div>
  );
}

export default App;
```

## Maintainers

[@meirdev](https://github.com/meirdev)

## License

This library is licensed under the [MIT License](./LICENSE).
