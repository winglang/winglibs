bring cloud;
bring sim;
bring ui;
bring util;

interface StartResponse {
  inflight port(): num;
  inflight close(): void;
}

struct SpecProps {
  outputDirectory: str?;
  specVersion: num?;
}

pub struct ServiceProps {
  entryFile: str?;
  controllerPathGlobs: Array<str>;
  outputDirectory: str;
  spec: SpecProps?;
  routesDir: str;
}

pub class Service {
  pub url: str;
  state: sim.State;
  service: cloud.Service;

  new(props: ServiceProps) {
    let target = util.env("WING_TARGET");
    if target != "sim" {
      throw "Unsupported target {target}";
    }

    this.state = new sim.State();
    this.url = "http://127.0.0.1:{this.state.token("port")}";
    new cloud.Endpoint(this.url);

    let entrypointDir = nodeof(this).app.entrypointDir;
    let workDir = nodeof(this).app.workdir;

    this.service = new cloud.Service(inflight () => {
      let res = Service.startService(entrypointDir, workDir, props);
      this.state.set("port", "{res.port()}");

      return inflight () => {
        res.close();
      };
    });

    this.setUi();
  }

  setUi() {
    nodeof(this.state).hidden = true;
    nodeof(this.service).hidden = true;

    new ui.Field("Url", inflight () => {
      return this.url;
    }, link: true);
  }

  extern "./lib.js" inflight static startService(entrypointDir: str, workDir: str, props: ServiceProps): StartResponse;
}
