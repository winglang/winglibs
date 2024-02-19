bring cloud;
bring "./ngrok.w" as ngrok;

let api = new cloud.Api();

api.get("/", inflight () => {
  return { 
    body: "hello?",
    status: 200 
  };
});

api.get("/world", inflight () => {
  return {
    body: "damn it!!",
    status: 200
  };
});

api.get("/uri", inflight () => {
  return {
    status: 200,
    body: "hey uri"
  };
});

let w = new cloud.Website(path: "./public");

let external = new ngrok.Tunnel(api.url, 
  domain: "eladbgithub.ngrok.dev",
  onConnect: inflight (url) => {
    log("onConnect called: {url}");
  }
);

external.onConnect(inflight (url) => {
  log("another onConnect callback: {url}");
});

new cloud.Function(inflight () => {
  log("ready {external.url}");
});

test "url" {
  log(external.url);
}