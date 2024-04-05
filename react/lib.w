bring cloud;
bring ui;
bring util;

bring "./shared.w" as appShared;
bring "./sim.w" as appSim;
bring "./tf-aws.w" as appTfAws;

pub class App {
  pub url: str;

  platform: appShared.IApp;

  new(props: appShared.AppPros) {
    let target = util.env("WING_TARGET");

    if target == "sim" {
      this.platform = new appSim.AppSim(props);
    } elif target == "tf-aws" {
      this.platform = new appTfAws.AppTfAws(props); 
    } else {
      throw "unknown platform {target}";
    }

    this.url = this.platform.getUrl();

    new ui.Field("url", inflight () => {
      return this.url;
    }, link: true);

    if target == "sim" {
      new cloud.Endpoint(this.url);
    }

    nodeof(this).color = "sky";
  }

  pub addEnvironment(key: str, value: str) {
    this.platform.addEnvironment(key, value);
  }
}
