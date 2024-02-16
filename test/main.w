bring cloud;
bring "../vite/vite.w" as vite;

let api = new cloud.Api();

let website = new vite.Vite(
  root: "../web",
  publicEnv: {
    HELLO_WORLD: "Hello, World!",
    API_URL: api.url,
  },
);

new cloud.OnDeploy(inflight () => {
  log(website.url);
});
