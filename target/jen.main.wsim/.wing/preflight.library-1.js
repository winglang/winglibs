"use strict";
module.exports = function({ $stdlib }) {
  const std = $stdlib.std;
  const fs = $stdlib.fs;
  const PackageManifest = $stdlib.std.Struct._createJsonSchema({id:"/PackageManifest",type:"object",properties:{name:{type:"string"},},required:["name",]});
  class Library extends $stdlib.std.Resource {
    constructor($scope, $id, dir) {
      super($scope, $id);
      const pkgjsonpath = String.raw({ raw: ["", "/package.json"] }, dir);
      const pkgjson = (fs.Util.readJson(pkgjsonpath));
      const manifest = ((json, validateOptions) => (PackageManifest._fromJson(json, validateOptions)))(pkgjson);
      {console.log(manifest.name)};
      const base = (fs.Util.basename(dir));
      const expected = String.raw({ raw: ["@winglibs/", ""] }, base);
      if ((((a,b) => { try { return require('assert').notDeepStrictEqual(a,b) === undefined; } catch { return false; } })(manifest.name,expected))) {
        throw new Error(String.raw({ raw: ["'name' in ", " is expected to be ", ""] }, pkgjsonpath, expected));
      }
      const workflowdir = ".github/workflows";
      (fs.Util.mkdir(workflowdir));
      const steps = [];
      (steps.push(({"name": "Checkout","uses": "actions/checkout@v3","with": ({"sparse-checkout": dir})})));
      (steps.push(({"name": "Setup Node.js","uses": "actions/setup-node@v3","with": ({"node-version": "18.x","registry-url": "https://registry.npmjs.org"})})));
      (steps.push(({"name": "Install winglang","run": "npm i -g winglang"})));
      (steps.push(({"name": "Install dependencies","run": "npm install","working-directory": dir})));
      (steps.push(({"name": "Test","run": "wing test","working-directory": dir})));
      (steps.push(({"name": "Pack","run": "wing pack","working-directory": dir})));
      (steps.push(({"name": "Publish","run": "npm publish *.tgz","working-directory": dir,"env": ({"NODE_AUTH_TOKEN": "\${{ secrets.NPM_TOKEN }}"})})));
      (fs.Util.writeYaml(String.raw({ raw: ["", "/", ".yaml"] }, workflowdir, base), ({"name": base,"on": ["push"],"jobs": ({"build": ({"runs-on": "ubuntu-latest","steps": [...(steps)]})})})));
    }
    static _toInflightType(context) {
      return `
        require("./inflight.Library-1.js")({
        })
      `;
    }
    _toInflight() {
      return `
        (await (async () => {
          const LibraryClient = ${Library._toInflightType(this)};
          const client = new LibraryClient({
          });
          if (client.$inflight_init) { await client.$inflight_init(); }
          return client;
        })())
      `;
    }
    _supportedOps() {
      return ["$inflight_init"];
    }
  }
  return { Library };
};
