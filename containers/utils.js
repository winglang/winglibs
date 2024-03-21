exports.entrypointDir = function (scope) {
  if (typeof(scope.entrypointDir) == "string") {
    return scope.entrypointDir;
  }

  return exports.entrypointDir(scope.node.scope);
};

exports.dirname = function() {
  return __dirname;
};

