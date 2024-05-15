bring http;
bring util;
bring cloud;
bring sim;
bring ui;
bring "./api.w" as api;

pub class Workload_sim {
  pub publicUrl: str?;
  pub internalUrl: str?;

  new(props: api.WorkloadProps) {
    let state = new sim.State();
    nodeof(state).hidden = true;

    let publicUrlKey = "public_url";
    let internalUrlKey = "internal_url";

    let c = new sim.Container(
      name: props.name,
      image: props.image,
      args: props.args,
      containerPort: props.port,
      env: this.toEnv(props.env),
      sourceHash: props.sourceHash,
      sourcePattern: props.sources,
    );

    nodeof(c).hidden = true;

    if props.port != nil {
      this.publicUrl = state.token(publicUrlKey);
      this.internalUrl = state.token(internalUrlKey);

      new ui.Field("url", inflight () => {
        return this.publicUrl!;
      });

      let readiness = new cloud.Service(inflight () => {
        let publicUrl = "http://localhost:{c.hostPort!}";

        if let readiness = props.readiness {
          // if we have a readiness check, wait for the container to be ready
          let readinessUrl = "{publicUrl}{readiness}";

          util.waitUntil(inflight () => {
            try {
              log("Readiness check: GET {readinessUrl}");
              return http.get(readinessUrl).ok;
            } catch {
              return false;
            }
          }, interval: 0.5s);

          log("Container is ready!");
        }

        // ready!
        state.set(publicUrlKey, publicUrl);
        state.set(internalUrlKey, "http://host.docker.internal:{c.hostPort!}");
      }) as "readiness";

      nodeof(readiness).hidden = true;
    }
  }

  toEnv(input: Map<str?>?): Map<str> {
    let env = MutMap<str>{};
    let i = input ?? {};
    for e in i.entries() {
      if e.value != nil {
        env.set(e.key, e.value!);
      }
    }

    return env.copy();
  }
}
