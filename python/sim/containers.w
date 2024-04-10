bring http;
bring util;
bring cloud;
bring sim;
bring fs;

pub class Util {
  pub static entrypointDir(scope: std.IResource): str {
    return std.Node.of(scope).app.entrypointDir;
  }

  pub static isPath(s: str): bool {
    return s.startsWith("/") || s.startsWith("./");
  }

  pub static inflight isPathInflight(s: str): bool {
    return s.startsWith("/") || s.startsWith("./");
  }

  pub static resolveContentHash(scope: std.IResource, props: ContainerOpts): str? {
    if !Util.isPath(props.image) {
      return nil;
    }

    if let hash = props.sourceHash {
      return hash;
    }

    let var hash = "";
    let imageDir = props.image;
    let sources = props.sources ?? ["**/*"];
    for source in sources {
      hash += fs.md5(imageDir, source);
    }

    return util.sha256(hash);
  }
}

pub struct ContainerOpts {
  name: str;
  image: str;

  /** Internal container port to expose */
  flags: Map<str>?;   // flags to pass to the docker run command
  port: num?;
  env: Map<str?>?;
  readiness: str?;    // http get
  replicas: num?;     // number of replicas
  public: bool?;      // whether the container should have a public url (default: false)
  args: Array<str>?;  // container arguments
  volumes: Map<str>?; // volumes to mount

  /** 
   * A list of globs of local files to consider as input sources for the container.
   * By default, the entire build context directory will be included.
   */
  sources: Array<str>?;

  /**
   * a hash that represents the container source. if not set,
   * and `sources` is set, the hash will be calculated based on the content of the
   * source files.
   */
  sourceHash: str?;
}

pub class Container {
  publicUrlKey: str?;
  internalUrlKey: str?;

  pub publicUrl: str?;
  pub internalUrl: str?;

  props: ContainerOpts;
  appDir: str;
  imageTag: str;
  public: bool;
  state: sim.State;

  runtimeEnv: cloud.Bucket;
  containerService: cloud.Service;
  readinessService: cloud.Service;

  new(props: ContainerOpts) {
    this.appDir = Util.entrypointDir(this);
    this.props = props;
    this.state = new sim.State();
    this.runtimeEnv = new cloud.Bucket();
    let containerName = util.uuidv4();

    let hash = Util.resolveContentHash(this, props);
    if let hash = hash {
      this.imageTag = "{props.name}:{hash}";
    } else {
      this.imageTag = props.image;
    }

    this.public = props.public ?? false;

    if this.public {
      if !props.port? {
        throw "'port' is required if 'public' is enabled";
      }

      let key = "public_url";
      this.publicUrl = this.state.token(key);
      this.publicUrlKey = key;
    }

    if props.port? {
      let key = "internal_url";
      this.internalUrl = this.state.token(key);
      this.internalUrlKey = key;
    }

    let pathEnv = util.tryEnv("PATH") ?? "";

    this.containerService = new cloud.Service(inflight () => {
      log("starting container...");

      let opts = this.props;

      // if this a reference to a local directory, build the image from a docker file
      if Util.isPathInflight(opts.image) {
        // check if the image is already built
        try {
          util.exec("docker", ["inspect", this.imageTag], { env: { PATH: pathEnv } });
          log("image {this.imageTag} already exists");
        } catch {
          log("building locally from {opts.image} and tagging {this.imageTag}...");
          util.exec("docker", ["build", "-t", this.imageTag, opts.image], { env: { PATH: pathEnv }, cwd: this.appDir });
        }
      } else {
        try {
          util.exec("docker", ["inspect", this.imageTag], { env: { PATH: pathEnv } });
          log("image {this.imageTag} already exists");
        } catch {
          log("pulling {this.imageTag}");
          try    {
            util.exec("docker", ["pull", this.imageTag], { env: { PATH: pathEnv } });
          } catch e {
            log("failed to pull image {this.imageTag} {e}");
            throw e;
          }
          log("image pulled");
        }
      }

      // start the new container
      let dockerRun = MutArray<str>[];
      dockerRun.push("run");
      dockerRun.push("--detach");
      dockerRun.push("--rm");

      dockerRun.push("--name", containerName);

      if let flags = opts.flags {
        if flags.size() > 0 {
          for k in flags.keys() {
            dockerRun.push("{k}={flags.get(k)}");
          }
        }
      }

      if let port = opts.port {
        dockerRun.push("-p");
        dockerRun.push("{port}");
      }

      if let env = opts.env {
        if env.size() > 0 {
          dockerRun.push("-e");
          for k in env.keys() {
            dockerRun.push("{k}={env.get(k)!}");
          }
        }
      }

      for key in this.runtimeEnv.list() {
        dockerRun.push("-e");
        dockerRun.push("{key}={this.runtimeEnv.get(key)}");
      }

      if let volumes = opts.volumes {
        if volumes.size() > 0 {
          dockerRun.push("-v");
          for volume in volumes.entries() {
            dockerRun.push("{volume.value}:{volume.key}");
          }
        }
      }

      dockerRun.push(this.imageTag);

      if let runArgs = this.props.args {
        for a in runArgs {
          dockerRun.push(a);
        }
      }

      log("starting container from image {this.imageTag}");
      log("docker {dockerRun.join(" ")}");
      let res = util.exec("docker", dockerRun.copy(), { env: { PATH: pathEnv } });
      let publicUrl = "http://localhost:{55566}";

        if let k = this.publicUrlKey {
          this.state.set(k, publicUrl);
        }
      log("containerName={containerName}");

      return () => {
        util.exec("docker", ["rm", "-f", containerName], { env: { PATH: pathEnv } });
      };
    }, {autoStart: false}) as "ContainerService";
    std.Node.of(this.containerService).hidden = true;

    this.readinessService = new cloud.Service(inflight () => {
      let opts = this.props;
      let var out: Json? = nil;
      util.waitUntil(inflight () => {
        try {
          out = Json.parse(util.exec("docker", ["inspect", containerName], { env: { PATH: pathEnv } }).stdout);
          return true;
        } catch {
          log("something went wrong");
          return false;
        }
      }, interval: 3s);

      if let port = opts.port {
        let hostPort = out?.tryGetAt(0)?.tryGet("NetworkSettings")?.tryGet("Ports")?.tryGet("{port}/tcp")?.tryGetAt(0)?.tryGet("HostPort")?.tryAsStr();
        if !hostPort? {
          throw "Container does not listen to port {port}";
        }

        let publicUrl = "http://localhost:{hostPort!}";

        if let k = this.publicUrlKey {
          this.state.set(k, publicUrl);
        }

        if let k = this.internalUrlKey {
          this.state.set(k, "http://host.docker.internal:{hostPort!}");
        }

        if let readiness = opts.readiness {
          let readinessUrl = "{publicUrl}{readiness}";
          log("waiting for container to be ready: {readinessUrl}...");
          util.waitUntil(inflight () => {
            try {
              return http.get(readinessUrl).ok;
            } catch {
              return false;
            }
          }, interval: 0.1s);
        }
      }
    }, {autoStart: false}) as "ReadinessService";
    std.Node.of(this.readinessService).hidden = true;

    std.Node.of(this.state).hidden = true;
  }

  pub inflight start(env: Map<str>) {
    for entry in env.entries() {
      this.runtimeEnv.put(entry.key, entry.value);
    }

    this.containerService.start();
    this.readinessService.start();
  }
}
