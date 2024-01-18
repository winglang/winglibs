bring cloud;
bring "./ngrok.w" as ngrok;

let api = new cloud.Api();

api.get("/", inflight () => {
  return {
    status: 200,
    body: "boo1m!"
  };
});

let web = new cloud.Website(path: "./public");

let t = new ngrok.Tunnel(api.url,
  onConnect: inflight (url: str) => {
    log("connected to {url}");
  }
);

new cloud.Function(inflight () => {
  log(t.url);
});
