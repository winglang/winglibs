bring cloud;
bring util;
bring fs;
bring sim;

interface ChildProcess {
  inflight kill(): void;
  inflight url(): str;
}

pub struct NgrokProps {
  domain: str?;
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

      let s = new cloud.Service(inflight () => {
        try {
          let child = Tunnel.spawn("node", Array<str?>["./ngrok.js", url, props?.domain]);
          log("ngrok: {child.url()} => {url}");
          this.state.set("url", child.url());
          return () => {
            child.kill();
          };
        } catch e {
          log("error: {e}");

          // this is needed, the exception will cause any dependents to never be initialized
          this.state.set("url", "<error>");
        }        
      });
 
      // no need to show the ugly details
      nodeof(s).hidden = true;
      nodeof(this.state).hidden = true;
    }
  }

  extern "./util.js"
  static inflight spawn(cmd: str, args: Array<str?>, opts: Json?): ChildProcess;
}