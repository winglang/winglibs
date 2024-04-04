bring cloud;
bring ui;
bring util;

bring "./shared.w" as reactAppShared;
bring "./sim.w" as reactAppsim;
bring "./tf-aws.w" as reactAppTfAws;

pub class ReactApp {
  pub url: str;

  platform: reactAppShared.IReactApp;

  new(props: reactAppShared.ReactAppPros) {
    if util.env("WING_TARGET") == "sim" {
      this.platform = new reactAppsim.ReactAppSim(props);
    } elif util.env("WING_TARGET") == "tf-aws" {
      this.platform = new reactAppTfAws.ReactAppTfAws(props); 
    } else {
      throw "unknown platform";
    }

    this.url = this.platform.getUrl();

    new ui.Field("url", inflight () => {
      return this.url;
    }, link: true);

    if util.env("WING_TARGET") == "sim" {
      new cloud.Endpoint(this.url);
    }

    nodeof(this).color = "sky";
  }

  pub addEnvironment(key: str, value: str) {
    this.platform.addEnvironment(key, value);
  }
}
