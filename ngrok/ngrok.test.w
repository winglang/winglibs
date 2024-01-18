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

let external = new ngrok.Tunnel(api.url);

test "ngrok" {
  log("ready {external.url}");
}
