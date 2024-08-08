const cdk8s = require('cdk8s');
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

class LazyResolver {
  resolve(context) {
    if (typeof(context.value.produce) === "function") {
      const resolved = context.value.produce();
      context.replaceValue(resolved);
    }
  }
}

exports.toHelmChart = function (wingdir, chart) {
  const app = cdk8s.App.of(chart);

  app.resolvers = [new LazyResolver(), new cdk8s.LazyResolver(), new cdk8s.ImplicitTokenResolver(), new cdk8s.NumberStringUnionResolver()];
  const docs = cdk8s.App._synthChart(chart);
  const yaml = cdk8s.Yaml.stringify(...docs);

  const hash = crypto.createHash("md5").update(yaml).digest("hex");
  const reldir = `helm/${chart.name}-${hash}`;

  const workdir = path.join(wingdir, reldir);
  const templates = path.join(workdir, "templates");
  fs.mkdirSync(templates, { recursive: true });
  fs.writeFileSync(path.join(templates, "all.yaml"), yaml);

  const manifest = {
    apiVersion: "v2",
    name: chart.name,
    description: chart.node.path,
    type: "application",
    version: "0.1.0",
    appVersion: hash,
  };

  const chartyaml = path.join(workdir, "Chart.yaml");
  fs.writeFileSync(chartyaml, cdk8s.Yaml.stringify(manifest));

  return path.join("./", ".wing", reldir);
};
