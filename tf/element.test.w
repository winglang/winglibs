bring util;
bring "./element.w" as e;

if util.env("WING_TARGET").startsWith("tf") {
  new e.Element({
    provider: [
      { foo: "bar" },
      { baz: "qux" }
    ]
  });
}