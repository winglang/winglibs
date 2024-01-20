exports.createBundle = require('@winglang/sdk/lib/shared/bundling').createBundle;

exports.patchToInflight = (handler, code) => {
  handler._toInflight = () => `
    (function() {
      if (!global.entrypoint) {
        const x = {};
        (function(exports) {
          ${code}
        })(x);

        global.entrypoint = {
          handle: x.handler
        };
      }

      return global.entrypoint;
    })()
  `;
};