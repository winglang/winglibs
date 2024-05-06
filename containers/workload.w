bring util;
bring "./workload.sim.w" as sim;
bring "./workload.tfaws.w" as tfaws;
bring "./api.w" as api;
bring "./helm.w" as helm;
bring http;
bring fs;

pub class Workload {
  /** internal url, `nil` if there is no exposed port */
  pub internalUrl: str?;

  /** extern url, `nil` if there is no exposed port or if `public` is `false` */
  pub publicUrl: str?;

  new(props: api.WorkloadProps) {
    let target = util.env("WING_TARGET");

    if target == "sim" {
      let w = new sim.Workload_sim(props) as props.name;
      this.internalUrl = w.internalUrl;
      this.publicUrl = w.publicUrl;
      return this;
    }
    
    let provider = this.resolveProvider(target);
    if provider == "eks" {
      let w = new tfaws.Workload_tfaws(props) as props.name;
      this.internalUrl = w.internalUrl;
      this.publicUrl = w.publicUrl;
      return this;
    }

    if provider == "helm" {
      let w = new helm.Chart(props);
      this.internalUrl = "http://dummy";
      this.publicUrl = "http://dummy";
      w.toHelm(fs.join(nodeof(this).app.workdir, ".."));
      return this;
    }

    throw "unsupported provider {provider}";
  }

  resolveProvider(target: str): str {
    let allowed = ["eks", "helm"];
    let params: Json = nodeof(this).app.parameters.value("containers");
    let provider = params?.tryGet("provider")?.tryAsStr();
    if provider == nil {
      throw "Missing 'provider' under 'containers' in wing.toml. Allowed values are {allowed.join(", ")}";
    }

    if !allowed.contains(provider!) {
      throw "Invalid provider {provider!}. Allowed values are {allowed.join(", ")}";
    }

    return provider!;
  }
}
