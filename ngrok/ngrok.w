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
  onConnect: OnConnectHandler?;
}

pub class Tunnel {
  pub url: str;
  state: sim.State;

  new(url: str, props: NgrokProps?) {
    this.state = new sim.State();
    this.url = this.state.token("url");

    let s = new cloud.Service(inflight () => {
      try {
        let child = Tunnel.spawn("node", Array<str?>["./ngrok.js", url]);
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
  }

  extern "./util.js"
  static inflight spawn(cmd: str, args: Array<str?>, opts: Json?): ChildProcess;
}
