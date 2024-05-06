bring "./api.w" as api;
bring "cdk8s-plus-27" as plus;
bring "cdk8s" as cdk8s;

pub class Chart extends cdk8s.Chart {
  name: str;

  new(props: api.WorkloadProps) {
    let env = props.env ?? {};
    let envVariables = MutMap<plus.EnvValue>{};

    for k in env.keys() {
      if let v = env[k] {
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

  pub toHelm(workdir: str): str {
    return Chart.toHelmChart(workdir, this);
  }

  extern "./helm.js" pub static toHelmChart(wingdir: str, chart: cdk8s.Chart): str;
}
