bring util;

bring "./budget-sim.w" as sim;
bring "./budget-tfaws.w" as tfaws;
bring "./budget-shared.w" as shared;

pub class Alert {
  platform: shared.IAlert;

  new(props: shared.AlertProps) {
    if util.env("WING_TARGET") == "tf-aws" {
      this.platform = new tfaws.AlertTfAws(props);
    } elif util.env("WING_TARGET") == "sim" {
      this.platform = new sim.AlertSim(props);
    } else {
      throw "unknown platform";
    }
  }
}
