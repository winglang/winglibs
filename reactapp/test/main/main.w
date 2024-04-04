bring cloud;

bring "../../lib.w" as reactapp;

let api = new cloud.Api(cors: true);

api.get("/", inflight () => {
  return {
    status: 200,
    body: "Hello World! API",
  };
});

let project = new reactapp.ReactApp(
  projectPath: "../react-project",
  localPort: 4500,
);

project.addEnvironment("API_URL", api.url);
project.addEnvironment("TEXT", "Hello World!");
