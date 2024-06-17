bring cloud;
bring util;
bring sim;
bring http;
bring "../simutils/simutils.w" as simutils;

pub struct NgrokProps {
	url: str;
	domain: str?;
}

pub class Ngrok {
	pub url: str;
	new(props: NgrokProps) {
		let args = MutArray<str>[
			"http",
		];
		args.push(props.url);
		if let domain = props.domain {
			args.push("--domain");
			args.push(domain);
		}
		let ngrok = new simutils.Service(
			"ngrok",
			args.copy(),
			onData: inflight (data) => {
				log("[ngrok] {data}");
			},
		);
		let state = new sim.State();
		this.url = state.token("url");
   
		let urlRetriever = new cloud.Service(inflight () => {
      let var ngrokAPIPort = 4040;
      while ngrokAPIPort <= 4140 {
        let var retries = 3;
        while retries > 0 {
          try {
            let json = Json.parse(http.get("http://127.0.0.1:{ngrokAPIPort}/api/tunnels").body);
            for tunnel in Json.values(json["tunnels"]) {
              let address = tunnel["config"]["addr"].asStr();
              log("Checking {address}");
              if address == props.url {
                state.set("url", tunnel["public_url"].asStr());
                return nil;
              }
            }
          } finally {
            retries -= 1;
            util.sleep(50ms);
          }
        }
        ngrokAPIPort += 1;
      }
			throw "Couldn't find the ngrok tunnel for {props.url}";
		});
		nodeof(urlRetriever).addDependency(ngrok);
	}
}
