bring cloud;
bring util;
bring http;
bring math;
bring sim;
bring "../types.w" as types;
bring "../util.w" as libutil;

pub class Inflight impl cloud.IFunctionHandler {
  pub url: str;
  network: str?;
  lifts: MutMap<types.Lift>;
  clients: MutMap<types.LiftedSim>;

  new(props: types.InflightProps) {
    let homeEnv = util.tryEnv("HOME") ?? "";
    let pathEnv = util.tryEnv("PATH") ?? "";

    let outdir = libutil.build(
      nodePath: nodeof(this).path,
      path: props.path,
      handler: props.handler,
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
    let platform = Inflight.os();
    if platform != "darwin" && platform != "win32" {
      this.network = "host";
    }

    let runner = new sim.Container(
      image: outdir,
      name: "python-runner",
      volumes: [
        "{props.path}:/var/task:ro",
      ],
      env: {
        DOCKER_LAMBDA_STAY_OPEN: "1",
        WING_TARGET: util.env("WING_TARGET"),
      },
      containerPort: port,
      args: args,
      network: this.network,
      entrypoint: "/usr/local/bin/aws-lambda-rie",
    );

    this.url = "http://localhost:{runner.hostPort!}/2015-03-31/functions/function/invocations";
    this.clients = MutMap<types.LiftedSim>{};

    if let lift = props.lift {
      this.lifts = lift.copyMut();
    } else {
      this.lifts = MutMap<types.Lift>{};
    }
  }

  inflight context(): Map<str> {
    let clients = MutMap<Json>{};
    for client in this.clients.entries() {
      let value = client.value;

      // TODO: move it to a function (there's a weird bug going on here)
      let collect = inflight (value: types.LiftedSim) => {
        let c = MutMap<Json>{};
        if let children = value.children {
          for child in children.entries() {
            c.set(child.key, collect(child.value));
          }
        }

        if let handle = util.tryEnv(value.handle) {
          // sdk resources
          return {
            id: value.id,
            type: value.type,
            path: value.path,
            target: value.target,
            props: value.props,
            children: c.copy(),
            handle: handle,
          };
        } else {
          // custom resources
          return {
            id: value.id,
            type: value.type,
            path: value.path,
            target: value.target,
            props: value.props,
            children: c.copy(),
            handle: value.handle,
          };
        }
      };
      clients.set(client.key, collect(value));
    }

    let env = MutMap<str>{
      "WING_CLIENTS" => Json.stringify(clients),
    };

    let var host = "http://host.docker.internal";
    if let network = this.network {
      if network == "host" {
        host = "http://127.0.0.1";
      }
    }

    for e in Inflight.env().entries() {
      env.set(e.key, e.value);
    }

    for e in env.entries() {
      let var value = e.value;
      if value.contains("http://localhost") {
        value = value.replaceAll("http://localhost", host);
      } elif value.contains("http://127.0.0.1") {
        value = value.replaceAll("http://127.0.0.1", host);
      }
      env.set(e.key, value);
    }

    return env.copy();
  }

  pub inflight handle(event: str?): str? {
    return this._handle(event);
  }

  protected inflight _handle(event: str?): str? {
    let context = Json.stringify(this.context());
    let var body = event;
    if event == nil || event == "" {
      body = Json.stringify({ payload: "", context: context });
    } else {
      if let json = Json.tryParse(event) {
        body = Json.stringify({ payload: json, context: context });
      } else {
        body = Json.stringify({ payload: event, context: context });
      }
    }
    
    let res = http.post(this.url, { body: body });
    return res.body;
  }

  pub lift(obj: std.Resource, options: types.LiftOptions): cloud.IFunctionHandler {
    this.lifts.set(options.id, { obj: obj, allow: options.allow });
    return this;
  }

  pub preLift(host: std.IInflightHost) {
    for lift in this.lifts.entries() {
      libutil.liftSim(
        lift.value.obj, 
        { id: lift.key, allow: lift.value.allow }, 
        host, 
        this.clients
      );
    }
  }

  extern "./util.js" inflight static env(): Map<str>;
  extern "./util.js" static os(): str;
}
