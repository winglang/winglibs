"use strict";
const $stdlib = require('@winglang/sdk');
const $platforms = ((s) => !s ? [] : s.split(';'))(process.env.WING_PLATFORMS);
const $outdir = process.env.WING_SYNTH_DIR ?? ".";
const $wing_is_test = process.env.WING_IS_TEST === "true";
const std = $stdlib.std;
const fs = $stdlib.fs;
const l = require("./preflight.library-1.js")({ $stdlib });
class $Root extends $stdlib.std.Resource {
  constructor($scope, $id) {
    super($scope, $id);
    const PackageManifest = $stdlib.std.Struct._createJsonSchema({id:"/PackageManifest",type:"object",properties:{name:{type:"string"},},required:["name",]});
    (fs.Util.remove(".github/workflows"));
    for (const file of (fs.Util.readdir("."))) {
      if ((!(fs.Util.exists(String.raw({ raw: ["", "/package.json"] }, file))))) {
        continue;
      }
      new l.Library(this, file, file);
    }
  }
}
const $PlatformManager = new $stdlib.platform.PlatformManager({platformPaths: $platforms});
const $APP = $PlatformManager.createApp({ outdir: $outdir, name: "jen.main", rootConstruct: $Root, isTestEnvironment: $wing_is_test, entrypointDir: process.env['WING_SOURCE_DIR'], rootId: process.env['WING_ROOT_ID'] });
$APP.synth();
