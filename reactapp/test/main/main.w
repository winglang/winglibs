bring cloud;
bring expect;
bring http;
bring util;

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

if util.env("WING_TARGET") == "sim" {
  test "we can access the app" {
    let url = project.url;
  
    util.waitUntil(inflight () => {
      try {
        let response = http.get(url);
        return response.status == 200;
      } catch e {
        return false;
      }
    }, timeout: 10s);
  
    let response = http.get(url);

    expect.equal(response.status, 200);
  
    assert(response.body.startsWith("<!DOCTYPE html>"));
  }

  test "wing.js content" {
    let url = project.url + "/wing.js";
  
    util.waitUntil(inflight () => {
      try {
        let response = http.get(url);
        return response.status == 200;
      } catch e {
        return false;
      }
    }, timeout: 10s);
  
    let response = http.get(url);

    expect.equal(response.status, 200);

    assert(response.body.contains("\"TEXT\":\"Hello World!\""));
    assert(response.body.contains("\"API_URL\":\"{api.url}\""));
  }
}
