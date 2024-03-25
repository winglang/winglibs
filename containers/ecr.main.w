bring "./tfaws-ecr.w" as ecr;
bring util;

class Extern {
  pub static extern "./utils.js" dirname(): str;
}

if util.env("WING_TARGET") == "tf-aws" {
  new ecr.Repository(
    name: "my-repository",
    directory: Extern.dirname() + "/test/my-app",
    tag: "tag1"
  );
}

