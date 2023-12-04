bring util;
bring "./workload.sim.w" as sim;
bring "./workload.tfaws.w" as tfaws;
bring "./api.w" as api;
bring "./utils.w" as utils;

bring http;

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

    } elif target == "tf-aws" {
      let w = new tfaws.Workload_tfaws(props) as props.name;
      this.internalUrl = w.internalUrl;
      this.publicUrl = w.publicUrl;
    } else {
      throw "unsupported target {target}";
    }
  }
}
