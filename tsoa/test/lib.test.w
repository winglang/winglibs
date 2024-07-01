bring cloud;
bring http;
bring expect;
bring fs;
bring "../lib.w" as tsoa;
bring "../builder" as builder;

struct User {
  id: num;
  name: str;
}

let bucket = new cloud.Bucket();
let service = new tsoa.Service(
  controllers: [fs.join(@dirname, "assets/*.ts")],
);

service.lift(obj: bucket, id: "bucket", allow: ["put"]);

test "will start tsoa service" {
  let res = http.get("{service.url}/users/123?name=stam");
  expect.equal(res.status, 200);

  let user = User.parseJson(res.body);
  expect.equal(user.id, 123);
  expect.equal(user.name, "stam");
  // expect.equal(bucket.get("123"), "stam");
}
