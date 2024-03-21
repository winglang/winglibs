bring http;
bring util;
bring cloud;
bring sim;
bring ui;
bring "./api.w" as api;
bring "./utils.w" as utils;

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

      let s1 = new cloud.Service(inflight () => {
        state.set(publicUrlKey, "http://localhost:{c.hostPort!}");
        state.set(internalUrlKey, "http://host.docker.internal:{c.hostPort!}");
      }) as "urls";

      let s2 = new cloud.Service(inflight () => {
        if let readiness = props.readiness {
          let readinessUrl = "{this.publicUrl!}{readiness}";
          log("waiting for container to be ready: {readinessUrl}...");
          util.waitUntil(inflight () => {
            try {
              return http.get(readinessUrl).ok;
            } catch {
              return false;
            }
          }, interval: 0.1s);
        }
      }) as "readiness";

      nodeof(s1).hidden = true;
      nodeof(s2).hidden = true;
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
