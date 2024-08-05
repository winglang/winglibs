bring cloud;
bring util;
bring http;
bring math;
bring sim;
bring "./containers.w" as containers;
bring "../types.w" as types;
bring "../util.w" as libutil;

pub class Inflight impl cloud.IFunctionHandler {
  pub url: str;
  service: cloud.Service;
  network: str?;
  clients: MutMap<types.LiftedSim>;

  new(props: types.InflightProps) {
    let homeEnv = util.tryEnv("HOME") ?? "";
    let pathEnv = util.tryEnv("PATH") ?? "";

    let outdir = libutil.buildSim(
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

    let runner = new containers.Container(
      image: outdir,
      name: "python-runner",
      volumes: {
        "/var/task:ro,delegated": props.path,
      },
      env: {
        DOCKER_LAMBDA_STAY_OPEN: "1",
      },
      public: true,
      port: port,
      exposedPort: port,
      args: args,
      flags: flags.copy(),
      network: this.network,
      entrypoint: "/usr/local/bin/aws-lambda-rie",
    );
    
    this.service = new cloud.Service(inflight () => {
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
        } else if value.contains("http://127.0.0.1") {
          value = value.replaceAll("http://127.0.0.1", host);
        }
        env.set(e.key, value);
      }

      runner.start(env.copy());
    });

    this.url = "{runner.publicUrl!}/2015-03-31/functions/function/invocations";
    this.clients = MutMap<types.LiftedSim>{};

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
    if !res.ok {
      log("Failed to invoke the function: {Json.stringify(res)}");
    }
    return res.body;
  }

  pub lift(obj: std.Resource, options: types.LiftOptions): cloud.IFunctionHandler {
    libutil.liftSim(obj, options, this.service, this.clients);
    return this;
  }

  extern "./util.js" inflight static env(): Map<str>;
  extern "./util.js" static os(): str;
}
