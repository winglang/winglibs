bring "../eks/tfaws-ecr.w" as ecr;
bring util;

if util.env("WING_TARGET") == "tf-aws" {
  new ecr.Repository(
    name: "my-repository",
    directory: "{@dirname}/test/my-app",
    tag: "tag1"
  );
}

