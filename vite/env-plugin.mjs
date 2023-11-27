import { mkdir, writeFile } from "node:fs/promises";

const PACKAGE_NAME = "@winglibs/vite";

const DEFAULT_TYPES_DIRECTORY = ".wingcloud";

/**
 * @param {string} value
 * @param {string|string[]} prefix
 * @return {boolean}
 */
const startsWith = (value, prefix) => {
  if (Array.isArray(prefix)) {
    return prefix.some((p) => value.startsWith(p));
  }

  return value.startsWith(prefix);
};

/**
 * @return {import("vite").Plugin}
 */
export const env = () => {
  /**
   * @type {{
   *  root?: string;
   *  envPrefix?: string|string[];
   * }}
   */
  const context = {};
  return {
    name: `${PACKAGE_NAME}:env`,
    configResolved(config) {
      context.root = config.root;
      context.envPrefix = config.envPrefix ?? "VITE_";
    },
    async buildStart() {
      if (!context.root) {
        throw new Error("[root] is missing");
      }

      if (!context.envPrefix) {
        throw new Error("[envPrefix] is missing");
      }

      const root = `file://${context.root}/`;
      const envPrefix = context.envPrefix;

      this.debug("Generating type definitions...");
      let dts = [
        `// Generated by ${PACKAGE_NAME}. Do not edit.`,
        "interface ImportMetaEnv {",
      ];
      try {
        const env = process.env;
        for (const [key, value] of Object.entries(env ?? {})) {
          if (!startsWith(key, envPrefix)) {
            continue;
          }
          const type = typeof value === "string" ? "string" : "unknown";
          dts.push(
            `\t/** Generated by \`${PACKAGE_NAME}\`. */`,
            `\treadonly ${key}: ${type};`
          );
        }
      } catch (error) {
        this.error(
          error instanceof Error
            ? error
            : new Error("Unknown error", { cause: error })
        );
      }
      dts.push(
        "}",
        "",
        "interface ImportMeta {",
        "\treadonly env: ImportMetaEnv;",
        "}",
        ""
      );

      const dir = new URL(`${DEFAULT_TYPES_DIRECTORY}/`, root);
      await mkdir(dir, { recursive: true });
      await writeFile(new URL("env.d.ts", dir), dts.join("\n"));
    },
  };
};
