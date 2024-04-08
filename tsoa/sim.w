bring cloud;
bring sim;
bring ui;
bring util;
bring "./types.w" as types;

interface StartResponse {
  inflight port(): num;
  inflight close(): void;
}

/**
 * Starts a new TSOA service.
 */
pub class Service_sim impl types.IService {
  pub url: str;
  state: sim.State;
  service: cloud.Service;
  clients: MutMap<std.Resource>;

  new(props: types.ServiceProps) {
    let target = util.env("WING_TARGET");
    if target != "sim" {
      throw "Unsupported target {target}";
    }

    this.state = new sim.State();
    this.url = "http://127.0.0.1:{this.state.token("port")}";

    let currentdir = Service_sim.dirname();
    let entrypointDir = nodeof(this).app.entrypointDir;
    let workDir = nodeof(this).app.workdir;
    let homeEnv = util.tryEnv("HOME") ?? "";
    let pathEnv = util.tryEnv("PATH") ?? "";

    this.clients = MutMap<std.Resource>{};
    this.service = new cloud.Service(inflight () => {
      let res = Service_sim.startService(
        currentdir: currentdir,
        basedir: entrypointDir,
        workdir: workDir,
        options: props,
        homeEnv: homeEnv,
        pathEnv: pathEnv,
        clients: this.clients.copy(),
      );
      this.state.set("port", "{res.port()}");

      return inflight () => {
        res.close();
      };
    });

    this.addUi();
  }

  addUi() {
    nodeof(this.state).hidden = true;

    new ui.Field("Url", inflight () => {
      return this.url;
    }, link: true);
  }

  pub liftClient(id: str, client: std.Resource, ops: Array<str>) {
    client.onLift(this.service, ops);
    this.clients.set(id, client);
  }

  extern "./lib.js" inflight static startService(options: types.StartServiceOptions): StartResponse;
  extern "./lib.js" static dirname(): str;
}
