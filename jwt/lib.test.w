bring expect;
bring util;
bring "./lib.w" as jwt;

test "sign and verify" {
  let id = util.nanoid();
  let token = jwt.sign({ foo: id }, "shhhhh");
  let decoded1 = jwt.verify(token, secret: "shhhhh");
  expect.equal(decoded1["foo"].asStr(), id);

  let token2 = jwt.sign({ foo: id }, "shhhhh", algorithm: "HS256");
  let decoded2 = jwt.verify(token2, secret: "shhhhh", options: { algorithms: ["HS256"] });
  expect.equal(decoded2["foo"].asStr(), id);
}

test "sign with notBefore" {
  try {
    let id = util.nanoid();
    let token = jwt.sign({ foo: id }, "shhhhh", { notBefore: 50m });
    let decoded1 = jwt.verify(token, secret: "shhhhh");
    expect.equal("not-id", id);
    log(Json.stringify(decoded1));
  } catch e {
    expect.equal(e, "jwt not active");
  }
}

test "sign with expiresIn" {
  try {
    let id = util.nanoid();
    let token = jwt.sign({ foo: id }, "shhhhh", { expiresIn: 0s });
    let decoded1 = jwt.verify(token, secret: "shhhhh");
    expect.equal("not-id", id);
    log(Json.stringify(decoded1));
  } catch e {
    expect.equal(e, "jwt expired");
  }
}

test "sign and decode" {
  let id = util.nanoid();
  let token = jwt.sign({ foo: id }, "shhhhh");
  let decoded1 = jwt.decode(token, complete: true);
  expect.equal(decoded1["payload"]["foo"].asStr(), id);
}
