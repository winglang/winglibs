bring cloud;
bring util;
bring http;
bring math;
bring "./containers.w" as containers;
bring "../types.w" as types;
bring "../util.w" as libutil;

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

    let port = math.floor(math.random() * 1000 + 9000);
    let runtimePort = math.floor(math.random() * 1000 + 9000);
    let args = Array<str>[
      "/var/runtime/bootstrap",
      props.handler,
      "--runtime-interface-emulator-address",
      "0.0.0.0:{port}",
      "--runtime-api-address",
      "127.0.0.1:{runtimePort}"
    ];
    let flags = MutMap<str>{};
    let var network: str? = nil;
    let platform = Inflight.os();
    if platform != "darwin" && platform != "win32" {
      network = "host";
    }

    let runner = new containers.Container(
      image: "public.ecr.aws/lambda/python:3.12",
      name: "python-runner",
      volumes: {
        "/var/task:ro,delegated": outdir,
      },
      env: {
        DOCKER_LAMBDA_STAY_OPEN: "1",
      },
      public: true,
      port: port,
      exposedPort: port,
      args: args,
      flags: flags.copy(),
      network: network,
      entrypoint: "/usr/local/bin/aws-lambda-rie",
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

      let var host = "http://host.docker.internal";
      if let network = network {
        if network == "host" {
          host = "http://127.0.0.1";
        }
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

    this.url = "{runner.publicUrl!}/2015-03-31/functions/function/invocations";

    this.clients = MutMap<Json>{};
    this.wingClients = MutMap<std.Resource>{};

    if let lifts = props.lift {
      for lift in lifts.entries() {
        this.lift(lift.value.obj, { id: lift.key, allow: lift.value.allow });
      }
    }
  }

  pub inflight handle(event: str?): str? {
    return this._handle(event);
  }

  protected inflight _handle(event: str?): str? {
    let var body = event;
    if event == nil || event == "" {
      body = Json.stringify({ payload: "" });
    } else {
      if let json = Json.tryParse(event) {
        body = Json.stringify({ payload: json });
      } else {
        body = Json.stringify({ payload: event });
      }
    }
    
    let res = http.post(this.url, { body: body });
    return res.body;
  }

  pub lift(obj: std.Resource, options: types.LiftOptions): cloud.IFunctionHandler {
    obj.onLift(this.service, options.allow);
    let lifted = libutil.liftSim(options.id, obj);
    this.clients.set(options.id, lifted);
    this.wingClients.set(options.id, obj);
    return this;
  }

  extern "./util.js" inflight static env(): Map<str>;
  extern "./util.js" static os(): str;
}
