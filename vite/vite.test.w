bring cloud;
bring expect;
bring util;
bring fs;
bring "./vite.w" as vite;

test "noop" {

}

if util.env("WING_TARGET") == "tf-aws" {
  let api = new cloud.Api();

  let website = new vite.Vite(
    root: "./example",
    publicEnv: {
      HELLO: "world",
      API_URL: api.url,
    },
  );

  test "build() generates an index.html file" {
    expect.equal(fs.exists("./example/dist/index.html"), true);
  }

  test "build() exposes environment variables to the index.html file" {
    let html = fs.readFile("./example/dist/index.html");
    expect.equal(html.contains(Json.stringify({
      HELLO: "world",
      API_URL: api.url,
    })), true);
  }
}
