bring cloud;
bring fs;
bring util;
bring "../types" as types;

/// Meant to be a singleton
pub class TSOABuilder {
  extern "./builder.ts"
  static prepareHandler(shouldBuildRoutes:bool, outputDirectory: str, controllerPathGlobs: MutArray<str>): inflight(Json): Json;

  extern "./service.ts"
  static inflight generateRoutes(generatorScript:str, outputDirectory: str, controllerPathGlobs: MutArray<str>): void;

  outputDirectory: str;
  pub controllers: MutArray<str>;
  pub specPath: str;
  pub service: cloud.Service?;

  new() {
    nodeof(this).hidden = true;
    let workdir = fs.absolute(nodeof(this).app.workdir);
    this.controllers = MutArray<str>[];
    this.outputDirectory = fs.join(workdir, ".tsoa");
    this.specPath = fs.join(this.outputDirectory, "swagger.json");

    if util.env("WING_TARGET") == "sim" {
      let dirname = @dirname;
      this.service = new cloud.Service(inflight () => {
        TSOABuilder.generateRoutes(fs.join(dirname, "tsoaGenerate.mjs"), this.outputDirectory, unsafeCast(this.controllers));
        log("SERVICE DONE");
      });
    }
  }

  pub makeHandler(): inflight (Json): Json {
    return TSOABuilder.prepareHandler(
      util.env("WING_TARGET") != "sim",
      this.outputDirectory,
      this.controllers,
    );
  }

  pub static singleton(node: std.Node): TSOABuilder {
    let app = node.app;
    let root = node.root;
    let tsoaId = "TSOABuilder";
    let var tsoaChild = nodeof(app).tryFindChild(tsoaId);
    if tsoaChild == nil {
      tsoaChild = nodeof(root).tryFindChild(tsoaId);
    }

    if tsoaChild == nil {
      // Hack for test vs console environment
      if nodeof(root).id == "Default" {
        tsoaChild = new TSOABuilder() as tsoaId in root;
      } else {
        tsoaChild = new TSOABuilder() as tsoaId in app;
      }
    }
    return unsafeCast(tsoaChild);
  }
}
