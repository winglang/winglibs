bring cloud;
bring fs;

pub class FunctionHandler impl cloud.IFunctionHandler {
  new(src: str) {
    Util.makeHandler(this, src);
  }

  pub inflight handle(event: str): str? {
    // dummy
  }
}

pub class QueueHandler impl cloud.IQueueSetConsumerHandler {
  new(src: str) {
    Util.makeHandler(this, src);
  }
  pub inflight handle(message: str): void {
    // dummy
  }
}

pub class ApiEndpointHandler impl cloud.IApiEndpointHandler {
  new(src: str) {
    Util.makeHandler(this, src);
  }
  pub inflight handle(request: cloud.ApiRequest): cloud.ApiResponse {
    return { status: 500 };
  }
}


struct Bundle {
  entrypointPath: str;
  directory: str;
  hash: str;
  outfilePath: str;
  sourcemapPath: str;
}


class Util {
  pub static makeHandler(handler: std.IResource, src: str) {
    nodeof(handler).hidden = true;
    let tmpdir = fs.mkdtemp();
    let bundle = Util.createBundle(src, [], tmpdir);
    let code = fs.readFile(bundle.entrypointPath);
    Util.patchToInflight(handler, code);
  }

  extern "./util.js"
  static patchToInflight(h: std.IResource, code: str): void;

  extern "./util.js"
  static createBundle(entrypoint: str, external: Array<str>?, outputDir: str?): Bundle;
}
