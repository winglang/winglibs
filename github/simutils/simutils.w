bring cloud;
bring util;
bring sim;

pub interface Process {
	inflight kill(): void;
}

pub struct ServiceProps {
	cwd: str?;
	env: Map<str>?;
	onData: inflight (str): void;
}

pub class Service {
	new(command: str, args: Array<str>, props: ServiceProps) {
		let commonEnv = Map<str>{
			"HOME" => util.env("HOME"),
			"PATH" => util.env("PATH"),
		};
		new cloud.Service(inflight () => {
			let env = commonEnv.copyMut();
			if let propsEnv = props.env {
				for key in propsEnv.keys() {
					env.set(key, propsEnv.get(key));
				}
			}
			let child = Service.spawn(
				command,
				args,
				cwd: props.cwd,
				env: env?.copy(),
				onData: props.onData,
			);
			return () => {
				child.kill();
			};
		});
	}
	extern "./simutils.js" static inflight spawn(file: str, args: Array<str>, props: ServiceProps?): Process;
}

pub class Port {
	pub port: str;
	new() {
		let state = new sim.State();
		this.port = state.token("port");
		new cloud.Service(inflight () => {
			state.set("port", "{Port.findPort()}");
		});
	}
	extern "./simutils.js" static inflight findPort(): num;
}
