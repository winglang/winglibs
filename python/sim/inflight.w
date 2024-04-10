bring cloud;
bring util;
bring http;
bring "./containers.w" as containers;
bring "../types.w" as types;
bring "../util.w" as libutil;

pub struct LiftOptions {
  allow: Array<str>;
}

pub class Inflight impl cloud.IFunctionHandler {
  pub url: str;
  service: cloud.Service;
  clients: MutMap<Json>;
  wingClients: MutMap<std.Resource>;

  new(props: types.InflightProps) {
    let entrypointDir = nodeof(this).app.entrypointDir;
    let workDir = nodeof(this).app.workdir;
    let homeEnv = util.tryEnv("HOME") ?? "";
    let pathEnv = util.tryEnv("PATH") ?? "";

    let outdir = libutil.build(
      entrypointDir: entrypointDir,
      workDir: workDir,
      path: props.path,
      homeEnv: homeEnv,
      pathEnv: pathEnv,
    );

    let flags = MutMap<str>{};
    let platform = Inflight.os();
    if platform != "darwin" && platform != "win32" {
      // flags.set("--add-host", "host.docker.internal:host-gateway");
      flags.set("--network", "host");
    }

    let runner = new containers.Container(
      image: "lambci/lambda:python3.8",
      name: "python-runner",
      volumes: {
        "/var/task:ro,delegated": outdir,
      },
      env: {
        DOCKER_LAMBDA_STAY_OPEN: "1",
      },
      public: true,
      port: 9001,
      args: [props.handler],
      flags: flags.copy(),
    );
    
    this.service = new cloud.Service(inflight () => {
      let clients = MutMap<Json>{};
      for client in this.wingClients.entries() {
        let value = MutJson this.clients.get(client.key);
        value.set("handle", util.env(value.get("handle").asStr()));
        clients.set(client.key, value);
      }

      let env = MutMap<str>{
        "WING_CLIENTS" => Json.stringify(clients),
      };

      log("calling wing simulator{util.env("WING_SIMULATOR_URL")}");
      let res = http.post("{util.env("WING_SIMULATOR_URL")}/v1/call", { body: Json.stringify({
        "caller": util.env("WING_SIMULATOR_CALLER"),
        "handle": clients.get("bucket"),
        "method": "put",
        "args": ["aaa", "bbb"],
      })});
      log("called {Json.stringify(res)}");
      let var host = "http://host.docker.internal";
      if platform != "darwin" && platform != "win32" {
        host = "http://127.0.0.1";
      }

      for e in Inflight.env().entries() {
        let var value = e.value;
        if value.contains("http://localhost") {
          value = value.replace("http://localhost", host);
        } elif value.contains("http://127.0.0.1") {
          value = value.replace("http://127.0.0.1", host);
        }
        env.set(e.key, value);
      }
      runner.start(env.copy());
    });

    this.url = "{runner.publicUrl!}/2015-03-31/functions/myfunction/invocations";

    this.clients = MutMap<Json>{};
    this.wingClients = MutMap<std.Resource>{};
  }

  pub inflight handle(event: str?): str? {
    let var body = event;
    if event == nil || event == "" {
      body = "\{}";
    }
    let res = http.post(this.url, { body: body });
    return res.body;
  }

  pub lift(id: str, client: std.Resource, options: LiftOptions): cloud.IFunctionHandler {
    client.onLift(this.service, options.allow);
    let lifted = libutil.liftSim(id, client);
    this.clients.set(id, lifted);
    this.wingClients.set(id, client);
    return this;
  }

  extern "./util.js" inflight static env(): Map<str>;
  extern "./util.js" static os(): str;
}
