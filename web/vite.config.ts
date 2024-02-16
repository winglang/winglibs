import { defineConfig } from "vite";
import { plugin } from "../vite/vite-plugin.mjs";

export default defineConfig({
  plugins: [
    // plugin({
    //   env: JSON.stringify({ hello: "world" }),
    //   envName: "wing",
    // }),
  ],
});
