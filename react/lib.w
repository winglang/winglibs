bring cloud;
bring ui;
bring util;

bring "./api.w" as appApi;
bring "./sim.w" as appSim;
bring "./tf-aws.w" as appTfAws;

pub class App {
  pub url: str;

  inner: appApi.IApp;

  new(props: appApi.AppProps) {
    let target = util.env("WING_TARGET");

    if target == "sim" {
      this.inner = new appSim.AppSim(props);
    } elif target == "tf-aws" {
      this.inner = new appTfAws.AppTfAws(props); 
    } else {
      throw "unknown platform {target}";
    }

    this.url = this.inner.getUrl();

    new ui.Field("url", inflight () => {
      return this.url;
    }, link: true);

    if target == "sim" {
      new cloud.Endpoint(this.url);
    }

    nodeof(this).color = "sky";
  }

  pub addEnvironment(key: str, value: str) {
    this.inner.addEnvironment(key, value);
  }
}
