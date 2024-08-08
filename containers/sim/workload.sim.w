bring http;
bring util;
bring cloud;
bring sim;
bring ui;
bring "../api.w" as api;

pub class Workload_sim impl api.IWorkload {
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

  pub forward(opts: api.ForwardOptions?): api.IForward {
    if this.publicUrl == nil {
      throw "Cannot forward requests to a non-public container";
    }

    return new Forward(this.publicUrl!, opts) as "forward_{util.nanoid()}";
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

class Forward impl api.IForward {
  containerUrl: str;
  route: str?;
  method: cloud.HttpMethod?;

  new(containerUrl: str, opts: api.ForwardOptions?) {
    this.containerUrl = containerUrl;
    this.route = opts?.route;
    this.method = opts?.method;

    if let r = this.route {
      if !r.startsWith("/") {
        throw "Route must start with '/'";
      }
    }
  }

  pub fromApi(): cloud.IApiEndpointHandler {
    return inflight (request) => {
      let var body = request.body;
      if request.method == cloud.HttpMethod.GET || request.method == cloud.HttpMethod.HEAD {
        body = nil;
      }

      let response = http.fetch("{this.containerUrl}{request.path}", {
        body: body,
        headers: request.headers,
        method: request.method,
      });

      return {
        body: response.body,
        status: response.status,
        headers: response.headers
      };
    };
  }

  pub fromQueue(): cloud.IQueueSetConsumerHandler {
    return inflight (message) => {
      let route = this.route ?? "/";
      let method = this.method ?? cloud.HttpMethod.POST;
      http.fetch("{this.containerUrl}{route}", {
        body: message,
        method: method,
      });
    };
  }

  pub fromTopic(): cloud.ITopicOnMessageHandler {
    return inflight (message) => {
      let route = this.route ?? "/";
      let method = this.method ?? cloud.HttpMethod.POST;
      http.fetch("{this.containerUrl}{route}", {
        body: message,
        method: method,
      });
    };
  }

  pub fromSchedule(): cloud.IScheduleOnTickHandler {
    return inflight () => {
      let route = this.route ?? "/";
      let method = this.method ?? cloud.HttpMethod.GET;

      http.fetch("{this.containerUrl}{route}", {
        method: method,
      });
    };
  }

  pub fromBucketEvent(): cloud.IBucketEventHandler {
    return inflight (key, type) => {
      let route = this.route ?? "/";
      let method = this.method ?? cloud.HttpMethod.POST;
      let stype = () => {
        if type == cloud.BucketEventType.CREATE { return "create"; }
        if type == cloud.BucketEventType.UPDATE { return "update"; }
        if type == cloud.BucketEventType.DELETE { return "delete"; }
      }();

      http.fetch("{this.containerUrl}{route}", {
        method: method,
        body: Json.stringify({
          key: key,
          type: stype
        })
      });
    };
  }  
}