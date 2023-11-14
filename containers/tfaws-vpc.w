bring "@cdktf/provider-aws" as aws;
bring "cdktf" as cdktf;

struct VpcProps {
  publicSubnetTags: Map<str>?;
  privateSubnetTags: Map<str>?;
}

pub class Vpc {
  pub id: str;
  pub privateSubnets: Array<str>;
  pub publicSubnets: Array<str>;

  new(props: VpcProps?) {
    let available = new aws.dataAwsAvailabilityZones.DataAwsAvailabilityZones(filter: {
      name: "opt-in-status",
      values: ["opt-in-not-required"]
    });

    let publicSubnetTags = props?.publicSubnetTags ?? {};
    let privateSubnetTags = props?.privateSubnetTags ?? {};

    let vpc = new cdktf.TerraformHclModule(
      source: "terraform-aws-modules/vpc/aws",
      version: "4.0.2",
      variables: {
        cidr: "10.0.0.0/16",
        azs: cdktf.Fn.slice(available.names, 0, 3),
        private_subnets: ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"],
        public_subnets: ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"],

        enable_nat_gateway: true,
        single_nat_gateway: true,
        enable_dns_hostnames: true,

        public_subnet_tags: publicSubnetTags,
        private_subnet_tags: privateSubnetTags,
      }
    );

    this.id = vpc.get("vpc_id");
    this.privateSubnets = vpc.get("private_subnets");
    this.publicSubnets = vpc.get("public_subnets");
  }
}