import getPort, { portNumbers } from "get-port";

export const findPort = async () => {
	return getPort({
		port: portNumbers(3000, 3999),
	});
};

import * as child_process from "node:child_process";

export const spawn = async (command, args, options) => {
	let child = child_process.spawn(command, args, {
		cwd: options?.cwd,
		env: options?.env,
	});

	if (options?.onData) {
		child.stdout.on("data", (data) => options.onData(data.toString()));
		child.stderr.on("data", (data) => options.onData(data.toString()));
	}

	return {
		kill() {
			child.kill("SIGINT");
		},
	};
};