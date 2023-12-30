bring aws;
bring cloud;
bring "constructs" as c;
bring "cdktf" as cdktf;
bring "@cdktf/provider-helm" as helm;
bring "@cdktf/provider-kubernetes" as eks;
bring "./tfaws-vpc.w" as vpc;
bring "./values.w" as values;
bring "./aws.w" as aws_info;

struct ClusterAttributes {
  name: str;
  certificate: str;
  endpoint: str;
}

interface ICluster extends std.IResource {
  attributes(): ClusterAttributes;
  kubernetesProvider(): cdktf.TerraformProvider;
  helmProvider(): cdktf.TerraformProvider;
}

pub class ClusterBase impl ICluster {
  pub attributes(): ClusterAttributes { throw "Not implemented"; return { certificate: "", endpoint: "", name: "" }; }

  pub kubernetesProvider(): cdktf.TerraformProvider {
    let stack = cdktf.TerraformStack.of(this);
    let singletonKey = "WingKubernetesProvider";
    let attributes = this.attributes();
    let existing = stack.node.tryFindChild(singletonKey);
    if existing? {
      return unsafeCast(existing);
    }

    // setup the "kubernetes" terraform provider
    return new eks.provider.KubernetesProvider(
      host: attributes.endpoint,
      clusterCaCertificate: cdktf.Fn.base64decode(attributes.certificate),
      exec: {
        apiVersion: "client.authentication.k8s.io/v1beta1",
        args: ["eks", "get-token", "--cluster-name", attributes.name],
        command: "aws",
      }
    ) as singletonKey in stack;
  }

  pub helmProvider(): cdktf.TerraformProvider {
    let stack = cdktf.TerraformStack.of(this);
    let singletonKey = "WingHelmProvider";
    let attributes = this.attributes();
    let existing = stack.node.tryFindChild(singletonKey);
    if existing? {
      return unsafeCast(existing);
    }

    return new helm.provider.HelmProvider(kubernetes: {
      host: attributes.endpoint,
      clusterCaCertificate: cdktf.Fn.base64decode(attributes.certificate),
      exec: {
        apiVersion: "client.authentication.k8s.io/v1beta1",
        args: ["eks", "get-token", "--cluster-name", attributes.name],
        command: "aws",
      }
    }) as singletonKey in stack;
  }
}

class ClusterRef extends ClusterBase impl ICluster {
  _attributes: ClusterAttributes;

  new(attributes: ClusterAttributes) {
    this._attributes = attributes;
  }

  pub attributes(): ClusterAttributes {
    return this._attributes;
  }
}

pub class Cluster extends ClusterBase impl ICluster {

  /** singleton */
  pub static getOrCreate(scope: std.IResource): ICluster {
    let stack = cdktf.TerraformStack.of(scope);
    let uid = "WingEksCluster";
    let existing: ICluster? = unsafeCast(stack.node.tryFindChild(uid));
    let newCluster = (): ICluster => {
      if let attrs = Cluster.tryGetClusterAttributes() {
        return new ClusterRef(attrs) as uid in stack;
      } else {
        let clusterName = "wing-eks-{std.Node.of(scope).addr.substring(0, 6)}";
        return new Cluster(clusterName) as uid in stack;
      }
    };

    return existing ?? newCluster();
  }


  static tryGetClusterAttributes(): ClusterAttributes? {
    if !values.Values.has("eks.cluster_name") {
      return nil;
    }

    return ClusterAttributes {
      name: values.Values.get("eks.cluster_name"),
      certificate: values.Values.get("eks.certificate"),
      endpoint: values.Values.get("eks.endpoint"),
    };

  }

  _attributes: ClusterAttributes;
  _oidcProviderArn: str;

  vpc: vpc.Vpc;

  new(clusterName: str) {
    let privateSubnetTags = MutMap<str>{};
    privateSubnetTags.set("kubernetes.io/role/internal-elb", "1");
    privateSubnetTags.set("kubernetes.io/cluster/{clusterName}", "shared");

    let publicSubnetTags = MutMap<str>{};
    publicSubnetTags.set("kubernetes.io/role/elb", "1");
    publicSubnetTags.set("kubernetes.io/cluster/{clusterName}", "shared");

    this.vpc = new vpc.Vpc(
      privateSubnetTags: privateSubnetTags.copy(),
      publicSubnetTags: publicSubnetTags.copy(),
    );

    let cluster = new cdktf.TerraformHclModule(
      source: "terraform-aws-modules/eks/aws",
      version: "19.17.1",
      variables: {
        cluster_name: clusterName,
        cluster_version: "1.27",
        cluster_endpoint_public_access: true,
        cluster_addons: {
          "kube-proxy": {},
          "vpc-cni": {},
          coredns: {
            configuration_values: cdktf.Fn.jsonencode({
              computeType: "Fargate"
            })
          },
        },
        vpc_id: this.vpc.id,
        subnet_ids: this.vpc.privateSubnets,
        create_cluster_security_group: false,
        create_node_security_group: false,
        fargate_profiles: {
          default: {
            name: "default",
            selectors: [
              { namespace: "kube-system" },
              { namespace: "default" },
            ]
          }
        },
      }
    ) as "eks";

    this._attributes = {
      name: clusterName,
      certificate:  cluster.get("cluster_certificate_authority_data"),
      endpoint: cluster.get("cluster_endpoint"),
    };

    this._oidcProviderArn = cluster.get("oidc_provider_arn");

    // output the cluster name
    new cdktf.TerraformOutput(value: this._attributes.name, description: "eks.cluster_name") as "eks.cluster_name";
    new cdktf.TerraformOutput(value: this._attributes.certificate, description: "eks.certificate") as "eks.certificate";
    new cdktf.TerraformOutput(value: this._attributes.endpoint, description: "eks.endpoint") as "eks.endpoint";

    // install the LB controller to support ingress
    this.addLoadBalancerController();
  }

  pub attributes(): ClusterAttributes { 
    return this._attributes;
  }

  addLoadBalancerController() {
    let awsInfo = aws_info.Aws.getOrCreate(this);

    let serviceAccountName = "aws-load-balancer-controller";
    let lbRole = new cdktf.TerraformHclModule(
      source: "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks",
      variables: {
        role_name: "eks-lb-role-{this.node.addr}",
        attach_load_balancer_controller_policy: true,
        oidc_providers: {
          main: {
            provider_arn: this._oidcProviderArn,
            namespace_service_accounts: ["kube-system:{serviceAccountName}"],
          }
        }
      }
    ) as "lb_role";

    // install the k8s terraform provider

    let serviceAccount = new eks.serviceAccount.ServiceAccount(
      provider: this.kubernetesProvider(),
      metadata: {
        name: serviceAccountName,
        namespace: "kube-system",
        labels: {
          "app.kubernetes.io/name" => serviceAccountName,
          "app.kubernetes.io/component"=> "controller"
        },
        annotations: {
          "eks.amazonaws.com/role-arn" => lbRole.get("iam_role_arn"),
          "eks.amazonaws.com/sts-regional-endpoints" => "true"
        },
      }
    );
    
    new helm.release.Release(
      provider: this.helmProvider(),
      name: "aws-load-balancer-controller",
      repository: "https://aws.github.io/eks-charts",
      chart: "aws-load-balancer-controller",
      namespace: "kube-system",
      dependsOn: [serviceAccount],
      set: [
        { name: "region", value: awsInfo.region() },
        { name: "vpcId", value: this.vpc.id },
        { name: "serviceAccount.create", value: "false" },
        { name: "serviceAccount.name", value: serviceAccountName },
        { name: "clusterName", value: this._attributes.name },
      ]
    );
  }
}
