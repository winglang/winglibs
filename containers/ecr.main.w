bring "./tfaws-ecr.w" as ecr;
bring "./utils.w" as utils;
bring util;

if util.env("WING_TARGET") == "tf-aws" {
  new ecr.Repository(
    name: "my-repository",
    directory: utils.dirname() + "/test/my-app",
    tag: "tag1"
  );  
}

