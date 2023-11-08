"use strict";
module.exports = function({ $stdlib }) {
  const std = $stdlib.std;
  const fs = $stdlib.fs;
  class Library extends $stdlib.std.Resource {
    constructor($scope, $id, dir) {
      super($scope, $id);
      const pkgjson = (fs.Util.tryReadJson(String.raw({ raw: ["", "/package.json"] }, dir)));
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
