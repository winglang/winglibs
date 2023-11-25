bring cloud;
bring util;
bring sim;

pub class Port {
	pub port: str;

	new() {
		let state = new sim.State();

		this.port = state.token("port");

		new cloud.Service(inflight () => {
			state.set("port", "${Port.findPort()}");
		});
	}

	extern "./find-port.mjs" static inflight findPort(): num;
}
