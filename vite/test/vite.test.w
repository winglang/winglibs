bring cloud;
bring expect;
bring util;
bring fs;
bring "../vite.w" as vite;

if util.env("WING_TARGET") == "tf-aws" {
  let website = new vite.Vite(
    root: "./example",
    env: {
      VITE_HELLO: "world",
    },
  );

  new cloud.Service(inflight () => {
    log("url = ${website.url}");
  });

  test "build() generates an index.html file" {
    let html = fs.readFile("./example/dist/index.html");
    expect.equal(html.contains("<h1>Hello world</h1>"), true);
  }

  test "build() passes environment variables to vite" {
    let assets = fs.readdir("./example/dist/assets");
    let js = fs.readFile("./example/dist/assets/${assets.at(0)}");
    expect.equal(js.contains("console.log(\"world\")"), true);
  }
}
