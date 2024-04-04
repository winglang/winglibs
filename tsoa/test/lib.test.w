bring http;
bring expect;
bring "../lib.w" as tsoa;

struct User {
  id: num;
  name: str;
}

let service = new tsoa.Service(
  controllerPathGlobs: ["../test-assets/*Controller.ts"],
  outputDirectory: "../test-assets/build",
  routesDir: "../test-assets/build",
);

test "will start tsoa service" {
  let res = http.get("{service.url}/users/123?name=stam");
  expect.equal(res.status, 200);

  let user = User.parseJson(res.body);
  expect.equal(user.id, 123);
  expect.equal(user.name, "stam");
}
