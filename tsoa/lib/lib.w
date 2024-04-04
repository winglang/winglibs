bring cloud;
bring sim;
bring ui;
bring util;

interface StartResponse {
  inflight port(): num;
  inflight close(): void;
}

struct SpecProps {
  outputDirectory: str?;
  specVersion: num?;
}

/**
 * Properties for a new TSOA service.
 */
pub struct ServiceProps {
  /**
   * The entry point to your API
   */
  entryFile: str?;
  /**
   * An array of path globs that point to your route controllers that you would like to have tsoa include.
   */
  controllerPathGlobs: Array<str>;
  /**
   * Generated SwaggerConfig.json will output here
   */
  outputDirectory: str;
  /**
   * Extend generated swagger spec with this object
   */
  spec: SpecProps?;
  /**
   * Routes directory; generated routes.ts (which contains the generated code wiring up routes using middleware of choice) will be dropped here
   */
  routesDir: str;
}

/**
 * Starts a new TSOA service.
 */
pub class Service {
  pub url: str;
  state: sim.State;
  service: cloud.Service;

  new(props: ServiceProps) {
    let target = util.env("WING_TARGET");
    if target != "sim" {
      throw "Unsupported target {target}";
    }

    this.state = new sim.State();
    this.url = "http://127.0.0.1:{this.state.token("port")}";
    new cloud.Endpoint(this.url);

    let entrypointDir = nodeof(this).app.entrypointDir;
    let workDir = nodeof(this).app.workdir;

    this.service = new cloud.Service(inflight () => {
      let res = Service.startService(entrypointDir, workDir, props);
      this.state.set("port", "{res.port()}");

      return inflight () => {
        res.close();
      };
    });

    this.addUi();
  }

  addUi() {
    nodeof(this.state).hidden = true;
    nodeof(this.service).hidden = true;

    new ui.Field("Url", inflight () => {
      return this.url;
    }, link: true);
  }

  extern "./lib.js" inflight static startService(entrypointDir: str, workDir: str, props: ServiceProps): StartResponse;
}
