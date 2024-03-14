bring expect;
bring util;
bring "./lib.w" as jwt;

test "sign and verify" {
  let id = util.nanoid();
  let token = jwt.sign({ foo: id }, "shhhhh");
  let decoded1 = jwt.verify(token, secret: "shhhhh");
  expect.equal(decoded1.get("foo").asStr(), id);

  let token2 = jwt.sign({ foo: id }, "shhhhh", algorithm: "HS256");
  let decoded2 = jwt.verify(token2, secret: "shhhhh", options: { algorithms: ["HS256"] });
  expect.equal(decoded2.get("foo").asStr(), id);
}
