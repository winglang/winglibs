bring expect;
bring util;
bring "./lib.w" as l;

test "sign and verify" {
  let id = util.nanoid();
  let token = l.sign({ foo: id }, "shhhhh");
  let decoded1 = l.verify(token, secret: "shhhhh");
  expect.equal(decoded1.get("foo").asStr(), id);

  let token2 = l.sign({ foo: id }, "shhhhh", algorithm: "HS256");
  let decoded2 = l.verify(token2, secret: "shhhhh", options: { algorithms: ["HS256"] });
  expect.equal(decoded2.get("foo").asStr(), id);
}
