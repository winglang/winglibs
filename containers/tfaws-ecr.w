bring "@cdktf/provider-aws" as aws;
bring "cdktf" as cdktf;
bring "@cdktf/provider-null" as null_provider;
bring "./aws.w" as aws_info;

struct RepositoryProps {
  directory: str;
  name: str;
  tag: str;
}

pub class Repository {
  pub image: str;
  pub deps: Array<cdktf.ITerraformDependable>;

  new(props: RepositoryProps) {
    let deps = MutArray<cdktf.ITerraformDependable>[];

    let count = 5;

    let r = new aws.ecrRepository.EcrRepository(
      name: props.name,
      forceDelete: true,
      imageTagMutability: "IMMUTABLE",
      imageScanningConfiguration: {
        scanOnPush: true,
      }
    );

    deps.push(r);
    
    new aws.ecrLifecyclePolicy.EcrLifecyclePolicy(
      repository: r.name,
      policy: Json.stringify({
        rules: [
	        {
	          rulePriority: 1,
	          description: "Keep only the last {count} untagged images.",
	          selection: {
	            tagStatus: "untagged",
	            countType: "imageCountMoreThan",
	            countNumber: count
	          },
	          action: {
	            type: "expire"
	          }
	        }
	      ]
      })
    );

    let awsInfo = aws_info.Aws.getOrCreate(this);
    let region = awsInfo.region();
    let accountId = awsInfo.accountId();
    let image = "{r.repositoryUrl}:{props.tag}";
    let arch = "linux/amd64";

    // null provider singleton
    let root = nodeof(this).root;
    let nullProviderId = "NullProvider";
    if !root.node.tryFindChild(nullProviderId)? {
      new null_provider.provider.NullProvider() as nullProviderId in root;
    }
    
    let publish = new null_provider.resource.Resource(
      dependsOn: [r],
      triggers: {
        tag: image,
      },
      provisioners: [
        {
          type: "local-exec",
          command: [
            "aws ecr get-login-password --region {region} | docker login --username AWS --password-stdin {accountId}.dkr.ecr.{region}.amazonaws.com || exit 1",
            "docker buildx build --platform {arch} -t {image} {props.directory} || exit 1",
            "docker push {image} || exit 1",
          ].join("\n")
        }
      ],
    );

    deps.push(publish);

    this.image = image;
    this.deps = deps.copy();
  }
}
