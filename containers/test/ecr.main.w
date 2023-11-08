bring "../tfaws-ecr.w" as ecr;
bring "../utils.w" as utils;

new ecr.Repository(
  name: "my-repository",
  directory: utils.dirname() + "/test/my-app",
  tag: "tag1"
);
