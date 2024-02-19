import { parseArgs } from "node:util";
import { createServer, build, resolveConfig } from "vite";
import { createRequire } from "node:module";
import { plugin } from "./vite-plugin.mjs";
const { stringifyPayload } = createRequire(import.meta.url)("./util.cjs");

const args = parseArgs({
  allowPositionals: true,
  options: {
    options: {
      type: "string",
    },
  },
});

const options = JSON.parse(args.values.options);

/** @type {import("vite").InlineConfig} */
const config = {
  plugins: [plugin(options)],
  clearScreen: false,
};

const command = args.positionals[0];
if (!command) {
  throw new Error("Command is missing");
}

if (command === "dev") {
  const server = await createServer(config);

  await server.listen();

  console.log(
    stringifyPayload({
      url: server.resolvedUrls.local[0],
    })
  );

  if (options.openBrowser) {
    server.openBrowser();
  }
} else if (command === "build") {
  const resolvedConfig = await resolveConfig(config);
  console.log(
    stringifyPayload({
      outDir: resolvedConfig.build.outDir,
    })
  );
  console.log("build start");
  await build(config);
  console.log("build finished");
} else {
  throw new Error(`Unknown command: ${command}`);
}
