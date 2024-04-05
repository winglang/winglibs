bring cloud;
bring ui;
bring util;

bring "./shared.w" as reactAppShared;
bring "./sim.w" as reactAppsim;
bring "./tf-aws.w" as reactAppTfAws;

pub class App {
  pub url: str;

  platform: reactAppShared.IApp;

  new(props: reactAppShared.AppPros) {
    let target = util.env("WING_TARGET");

    if target == "sim" {
      this.platform = new reactAppsim.AppSim(props);
    } elif target == "tf-aws" {
      this.platform = new reactAppTfAws.AppTfAws(props); 
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
