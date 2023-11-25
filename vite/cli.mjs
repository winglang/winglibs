import { parseArgs } from "node:util";
import { createServer, build } from "vite";
import { env } from "./env-plugin.mjs";

const args = parseArgs({
  allowPositionals: true,
  options: {
    port: {
      type: "string",
    },
    open: {
      type: "boolean",
    },
  },
});

/** @type {import("vite").InlineConfig} */
const config = {
  plugins: [env()],
  server: {
    port: Number(args.values.port),
  },
  clearScreen: false,
};

const command = args.positionals[0];
if (!command) {
  throw new Error("Command is missing");
}

if (command === "dev") {
  const server = await createServer(config);

  await server.listen();

  server.printUrls();

  if (args.values.open) {
    server.openBrowser();
  }
} else if (command === "build") {
  await build(config);
} else {
  throw new Error(`Unknown command: ${command}`);
}
