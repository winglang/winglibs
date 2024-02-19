bring cloud;
bring util;
bring fs;
bring sim;

interface ChildProcess {
  inflight kill(): void;
  inflight url(): str;
}

pub interface OnConnectHandler {
  inflight handle(url: str): void;
}

pub struct NgrokProps {
  domain: str?;
  onConnect: OnConnectHandler?;
}

pub class Tunnel {
  pub url: str;
  state: sim.State;

  new(url: str, props: NgrokProps?) {
    this.state = new sim.State();
    this.url = this.state.token("url");

    if !nodeof(this).app.isTestEnvironment {
      if !util.tryEnv("NGROK_AUTHTOKEN")? {
        throw "NGROK_AUTHTOKEN is not defined";
      }

      let dirname = Tunnel.dirname();
      let s = new cloud.Service(inflight () => {
        try {
          let child = Tunnel.spawn("node", Array<str?>["{dirname}/ngrok.js", url, props?.domain]);
          log("ngrok: {child.url()} => {url}");
          let url = child.url();
          this.state.set("url", url);
          props?.onConnect?.handle(url);
          return () => {
            child.kill();
          };
        } catch e {
          log("error: {e}");

          // ugly: without this an exception will cause dependents to 
          // never be initialized and the app will fail to start
          this.state.set("url", "<error>");
        }        
      });
 
      // no need to show the ugly details
      nodeof(s).hidden = true;
      nodeof(this.state).hidden = true;
    } else {
      // ugly: without this an exception will cause dependents to 
      // never be initialized and the app will fail to start
      new cloud.Service(inflight () => {
        this.state.set("url", "<test>");
      });
    }
  }

  extern "./util.js"
  static inflight spawn(cmd: str, args: Array<str?>, opts: Json?): ChildProcess;

  extern "./util.js"
  static dirname(): str;
}