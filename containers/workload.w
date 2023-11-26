bring util;
bring "./workload.sim.w" as sim;
bring "./workload.tfaws.w" as tfaws;
bring "./api.w" as api;
bring "./utils.w" as utils;

pub class Workload impl api.IWorkload {
  inner: api.IWorkload;
  pub internalUrl: str?;
  pub publicUrl: str?;

  new(props: api.WorkloadProps) {
    let target = util.env("WING_TARGET");

    if target == "sim" {
      this.inner = new sim.Workload_sim(props) as props.name;
    } elif target == "tf-aws" {
      this.inner = new tfaws.Workload_tfaws(props) as props.name;
    } else {
      throw "unsupported target {target}";
    }

    
    this.internalUrl = this.inner.getInternalUrl();
    this.publicUrl = this.inner.getPublicUrl();
  }

  pub getInternalUrl(): str? {
    return this.inner.getInternalUrl();
  }

  pub getPublicUrl(): str? {
    return this.inner.getPublicUrl();
  }
}
