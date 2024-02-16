bring "../vite/vite.w" as vite;

let website = new vite.Vite(
  root: "../web",
  env: {
    HELLO_WORLD: "Hello, World!",
  },
);

bring cloud;
new cloud.OnDeploy(inflight () => {
  log(website.url);
});
