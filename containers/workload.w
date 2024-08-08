bring util;
bring "./sim/workload.sim.w" as sim;
bring "./eks/workload.tfaws.w" as tfaws;
bring "./api.w" as api;
bring "./helm/helm.w" as helm;
bring http;
bring fs;
bring ui;

pub class Workload impl api.IWorkload {
  /** internal url, `nil` if there is no exposed port */
  pub internalUrl: str?;

  /** extern url, `nil` if there is no exposed port or if `public` is `false` */
  pub publicUrl: str?;

  inner: api.IWorkload;

  new(props: api.WorkloadProps) {
    let target = util.env("WING_TARGET");

    if target == "sim" {
      let w = new sim.Workload_sim(props) as props.name;
      this.internalUrl = w.internalUrl;
      this.publicUrl = w.publicUrl;
      this.inner = w;
      nodeof(w).hidden = true;

      if let url = w.internalUrl {
        new ui.ValueField("Internal URL", url) as "internal_url";
      }

      if let url = w.publicUrl {
        new ui.ValueField("Public URL", url) as "public_url";
      }

      return this;
    }
    
    let provider = this.resolveProvider(target);
    if provider == "eks" {
      let w = new tfaws.Workload_tfaws(props) as props.name;
      this.internalUrl = w.internalUrl;
      this.publicUrl = w.publicUrl;
      this.inner = w;
      return this;
    }

    if provider == "helm" {
      let w = new helm.Chart(props);
      this.inner = w;
      this.internalUrl = "http://dummy";
      this.publicUrl = "http://dummy";
      w.toHelm(fs.join(nodeof(this).app.workdir, ".."));
      return this;
    }

    throw "unsupported provider {provider}";
  }

  pub forward(opts: api.ForwardOptions?): api.IForward {
    return this.inner.forward(opts);
  }

  resolveProvider(target: str): str {
    let value = (): str? => {
      if let p = util.tryEnv("WING_CONTAINERS_PROVIDER") {
        return p;
      }

      let params: Json = nodeof(this).app.parameters.value("containers");
      if let provider = params?.tryGet("provider")?.tryAsStr() {
        return provider;
      }
  
      return "ecs";
    };

    let allowed = ["eks", "helm", "ecs"];
    let provider = value();

    if provider == nil {
      throw "Missing 'provider' under 'containers' in wing.toml. Allowed values are {allowed.join(", ")}";
    }

    if !allowed.contains(provider!) {
      throw "Invalid provider {provider!}. Allowed values are {allowed.join(", ")}";
    }

    return provider!;
  }
}
