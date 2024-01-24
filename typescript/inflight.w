bring cloud;
bring fs;

pub struct Lift {
  obj: std.IResource;
  ops: Array<str>;
}

pub struct InflightProps {
  src: str;
  lift: Map<Lift>?;
}


pub class Inflight {
  code: str;
  lift: Map<Lift>;

  new(props: InflightProps) {
    let var src = props.src;

    let postfix = "/index";
    if !src.endsWith(postfix) {
      throw "src must end with /index (for now)";
    }

    src = src.substring(0, src.length - postfix.length);

    this.lift = props?.lift ?? {};

    let tmpdir = fs.mkdtemp();
    let bundle = Util.createBundle(src, [], tmpdir);
    this.code = fs.readFile(bundle.entrypointPath);

    nodeof(this).hidden = true;
  }

  pub forFunction(): cloud.IFunctionHandler {
    let h: cloud.IFunctionHandler = inflight (event: str): str? => { };
    Util.patchToInflight(h, this.lift, this.code);
    return h;
  }

  pub forQueueConsumer(): cloud.IQueueSetConsumerHandler {
    let h: cloud.IQueueSetConsumerHandler = inflight (event: str): str? => { };
    Util.patchToInflight(h, this.lift, this.code);
    return h;
  }

  pub forApiEndpoint(): cloud.IApiEndpointHandler {
    let h: cloud.IApiEndpointHandler = inflight (req: cloud.ApiRequest): cloud.ApiResponse => {
      return { status: 500 };
    };
    Util.patchToInflight(h, this.lift, this.code);
    return h;
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
  extern "./util.js"
  pub static patchToInflight(h: std.IInflight, lift: Map<Lift>, code: str): void;

  extern "./util.js"
  pub static createBundle(entrypoint: str, external: Array<str>?, outputDir: str?): Bundle;
}
