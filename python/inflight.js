const tryGetPythonInflight = (inflight) => {
  if (inflight._inflightType === "_inflightPython") {
    return inflight; 
  } else {
    // inflight was lifted to another inflight
    for (let l of inflight._liftMap?.handle || []) {
      const lifted = tryGetPythonInflight(l[0]);
      if (lifted) {
        return lifted;
      }
    }
  }
};

exports.tryGetPythonInflight = tryGetPythonInflight;
