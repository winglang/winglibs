bring "./tfaws-eks.w" as eks;
bring util;

if util.env("WING_TARGET") == "tf-aws" {
  // create an eks cluster
  new eks.Cluster("wing-eks");
}