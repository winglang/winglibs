bring cloud;
bring util;
bring http;
bring "./containers.w" as containers;
bring "../types.w" as types;
bring "../util.w" as libutil;

pub class Function impl types.IFunction {
  pub url: str;
  service: cloud.Service;
  clients: MutMap<Json>;
  wingClients: MutMap<std.Resource>;

  new(props: types.FunctionProps) {
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

    let runner = new containers.Workload_sim(
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

      let platform = Function.os();
      let var host = "http://host.docker.internal";
      if platform != "darwin" && platform != "win32" {
        host = "http://172.17.0.1";
      }

      for e in Function.env().entries() {
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

  pub liftClient(id: str, client: std.Resource, ops: Array<str>) {
    client.onLift(this.service, ops);
    let lifted = libutil.liftSim(id, client);
    this.clients.set(id, lifted);
    this.wingClients.set(id, client);
  }

  pub inflight invoke(payload: str?): str? {
    let res = http.post(this.url, { body: payload ?? "\{}" });
    return res.body;
  }

  extern "./util.js" inflight static env(): Map<str>;
  extern "./util.js" inflight static os(): str;
}
