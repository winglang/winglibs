bring fs;
bring expect;
bring "./lib.w" as yaml;

let json = {
  key1: ["value1", "value2"],
  key2: "value3",
};

let file = fs.readFile(fs.join(@dirname, "./test.yml"));
let value = yaml.parseValue(file);
expect.equal(value, json);
expect.equal(yaml.stringifyValue(json), file);

test "can parse and stringify yaml file" {
  let value = yaml.parse(file);
  expect.equal(value, json);
  expect.equal(yaml.stringify(json), file);
}
