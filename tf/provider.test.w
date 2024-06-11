bring expect;
bring util;
bring "./provider.w" as tf;

if util.env("WING_TARGET").startsWith("tf") {
  let provider = new tf.Provider(
    name: "dnsimple",
    source: "dnsimple/dnsimple",
    version: "1.6.0",
    attributes: {
      token: "dnsimple_token",
    }
  ) as "DnsimpleProvider";
  
  let tfconfig: Json = provider.toTerraform();
  expect.equal(tfconfig["terraform"]["required_providers"], { "dnsimple": { "source": "dnsimple/dnsimple", "version": "1.6.0" } });
  expect.equal(tfconfig["provider"], { "dnsimple": [{ "token": "dnsimple_token" }] });
}
