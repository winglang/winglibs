bring "./api.w" as api;
bring "./tfaws-eks.w" as eks;
bring "cdk8s-plus-27" as plus;
bring "cdk8s" as cdk8s;
bring "cdktf" as cdktf;
bring "./tfaws-ecr.w" as ecr;
bring "@cdktf/provider-kubernetes" as k8s;
bring "@cdktf/provider-helm" as helm_provider;
bring "./helm.w" as helm;
bring fs;

pub class Workload_tfaws {
  pub internalUrl: str?;
  pub publicUrl: str?;

  new(props: api.WorkloadProps) {
    let cluster = eks.Cluster.getOrCreate(this);
    let var image = props.image;
    let var deps = MutArray<cdktf.ITerraformDependable>[];

    if this.isPath(props.image) {
      let hash = this.resolveContentHash(props) ?? props.image;
      let appDir = nodeof(this).app.entrypointDir;
      let repository = new ecr.Repository(
        name: props.name,
        directory: appDir + "/" + props.image,
        tag: hash
      );

      image = repository.image;
      for d in repository.deps {
        deps.push(d);
      }
    }

    let chart = new helm.Chart(props);

    let release = new helm_provider.release.Release(
      provider: cluster.helmProvider(),
      dependsOn: deps.copy(),
      name: props.name,
      chart: chart.toHelm(nodeof(this).app.workdir),
      values: ["image: {image}"],
    );

    if let port = props.port {
      this.internalUrl = "http://{props.name}:{port}";
    }

    // if "public" is set, lookup the address from the ingress resource created by the helm chart
    // and assign to `publicUrl`.
    if props.public ?? false {
      let ingress = new k8s.dataKubernetesIngressV1.DataKubernetesIngressV1(
        provider: cluster.kubernetesProvider(),
        dependsOn: [release],
        metadata: {
          name: props.name
        }
      );

      let hostname = ingress.status.get(0).loadBalancer.get(0).ingress.get(0).hostname;
      this.publicUrl = "http://{hostname}";
    }
  }

  isPath(s: str): bool {
    return s.startsWith("/") || s.startsWith("./");
  }
  
  resolveContentHash(props: api.WorkloadProps): str? {
    if !this.isPath(props.image) {
      return nil;
    }

    return props.sourceHash ?? fs.md5(props.image, props.sources);
  }
}

