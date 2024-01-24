const core = require('@winglang/sdk').core;

exports.createBundle = require('@winglang/sdk/lib/shared/bundling').createBundle;

exports.patchToInflight = (handler, lifts, code) => {
  const lifted = {};
  const permissions = [];

  for (const [name, lift] of Object.entries(lifts)) {
    lifted[name] = core.liftObject(lift.obj);
    permissions.push([lift.obj, lift.ops]);
  }

  const handleMethod = "handle";

  handler.onLift = (host, ops) => {
    core.onLiftMatrix(host, ops, {
      [handleMethod]: permissions,
    });
  };

  handler._toInflight = () => `
    (function() {
      const m = { exports: { } };
      const x = (module, exports) => { 
        ${code}
      };
      x(m, m.exports);
      const lifted = {};
      ${Object.entries(lifted).map(([name, value]) => `lifted["${name}"] = ${value};`).join("\n")}
      return { 
        ${handleMethod}: (...args) => m.exports.handler(lifted, ...args),
      };
    })()
  `;
};