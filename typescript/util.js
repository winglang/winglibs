exports.createBundle = require('@winglang/sdk/lib/shared/bundling').createBundle;

exports.patchToInflight = (handler, code) => {
  handler._toInflight = () => `
    (function() {
      const m = { exports: { } };
      const x = (module, exports) => { 
        ${code}
      };
      x(m, m.exports);
      return { 
        handle: (...args) => m.exports.handler({}, ...args),
      };
    })()
  `;
};