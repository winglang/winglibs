const cdk8s = require('cdk8s');
const { core, std } = require('@winglang/sdk');;

exports.Platform = class {
  target = "k8s";

  newApp(props) {
    const app = new cdk8s.App({ outdir: props.outdir });

    const labels = process.env.WING_K8S_LABELS ? JSON.parse(process.env.WING_K8S_LABELS) : {};
    const namespace = process.env.WING_K8S_NAMESPACE;
    const chart = new cdk8s.Chart(app, "Chart", { labels, namespace });

    class App extends core.App {
      _target = "cdk8s";
      outdir = props.outdir;

      constructor() {
        super(chart, "App", props);

        const root = this.node.root;
        root.new = (fqn, ctor, scope, id, ...args) => this.new(fqn, ctor, scope, id, ...args);
        root.newAbstract = (fqn, scope, id, ...args) => this.newAbstract(fqn, scope, id, ...args);
        root.typeForFqn = fqn => this.typeForFqn(fqn);

        std.Node._markRoot(props.rootConstruct);
        new props.rootConstruct(this, props.rootId ?? "Default");
      }

      synth() {
        app.synth();
        console.log(this.outdir);
      }
    }

    return new App();
  }
};
