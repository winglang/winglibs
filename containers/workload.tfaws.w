bring "./api.w" as api;
bring "./tfaws-eks.w" as eks;
bring "cdk8s-plus-27" as plus;
bring "cdk8s" as cdk8s;
bring "cdktf" as cdktf;
bring "./tfaws-ecr.w" as ecr;
bring "./utils.w" as utils;
bring "@cdktf/provider-kubernetes" as k8s;
bring "@cdktf/provider-helm" as helm;

pub class Workload_tfaws impl api.IWorkload {
  internalUrl: str?;
  publicUrl: str?;

  new(props: api.WorkloadProps) {
    let cluster = eks.Cluster.getOrCreate(this);

    let var image = props.image;
    let var deps = MutArray<cdktf.ITerraformDependable>[];

    if utils.isPath(props.image) {
      let hash = utils.resolveContentHash(this, props) ?? props.image;
      let appDir = utils.entrypointDir(this);
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

    class _Chart extends cdk8s.Chart {
      name: str;
    
      new(props: api.WorkloadProps) {
        let env = props.env ?? {};
        let envVariables = MutMap<plus.EnvValue>{};
    
        for k in env.keys() {
          if let v = env.get(k) {
            envVariables.set(k, plus.EnvValue.fromValue(v));
          }
        }
    
        let ports = MutArray<plus.ContainerPort>[];
        if let port = props.port {
          ports.push({ number: port });
        }
    
        let var readiness: plus.Probe? = nil;
        if let x = props.readiness {
          if let port = props.port {
            readiness = plus.Probe.fromHttpGet(x, port: port);
          } else {
            throw "Cannot setup readiness probe without a `port`";
          }
        }
    
        let deployment = new plus.Deployment(
          replicas: props.replicas,
          metadata: {
            name: props.name
          },
        );
    
        deployment.addContainer(
          image: "\{\{ .Values.image }}",
          envVariables: envVariables.copy(),
          ports: ports.copy(),
          readiness: readiness,
          args: props.args,
          securityContext: {
            ensureNonRoot: false,
          }
        );
    
        let isPublic = props.public ?? false;
        let var serviceType: plus.ServiceType? = nil;
    
        if isPublic {
          serviceType = plus.ServiceType.NODE_PORT;
        }
    
        let service = deployment.exposeViaService(
          name: props.name,
          serviceType: serviceType,
        );
    
        if isPublic {
          new plus.Ingress(
            metadata: {
              name: props.name,
              annotations: {
                "kubernetes.io/ingress.class": "alb",
                "alb.ingress.kubernetes.io/scheme": "internet-facing",
                "alb.ingress.kubernetes.io/target-type": "ip",
                "alb.ingress.kubernetes.io/healthcheck-protocol": "HTTP",
                "alb.ingress.kubernetes.io/healthcheck-port": "traffic-port",
                "alb.ingress.kubernetes.io/healthcheck-path": "/",
              }
            },
            defaultBackend: plus.IngressBackend.fromService(service),
          );
        }
    
        this.name = props.name;
      }
    
      pub toHelm(): str {
        return _Chart.toHelmChart(this);
      }
    
      extern "./helm.js" pub static toHelmChart(chart: cdk8s.Chart): str;
    }
    

    let chart = new _Chart(props);

    let release = new helm.release.Release(
      provider: cluster.helmProvider(),
      dependsOn: deps.copy(),
      name: props.name,
      chart: chart.toHelm(),
      values: ["image: {image}"],
    );

    if let port = props.port {
      this.internalUrl = "http://{props.name}:{props.port}";
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

  pub getPublicUrl(): str? {
    return this.publicUrl;
  }

  pub getInternalUrl(): str? {
    return this.internalUrl;
  }
}

