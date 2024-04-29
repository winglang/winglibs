const cdk8s = require('cdk8s');
const { core } = require('@winglang/sdk');;

exports.Platform = class {
  target = "cdk8s";

  newApp(props) {
    const app = new cdk8s.App({ outdir: props.outdir });
    const chart = new cdk8s.Chart(app, "Chart");

    class App extends core.App {
      _target = "cdk8s";
      outdir = props.outdir;

      constructor() {
        super(chart, "App", props);

        const root = this.node.root;
        root.new = (fqn, ctor, scope, id, ...args) => this.new(fqn, ctor, scope, id, ...args);
        root.newAbstract = (fqn, scope, id, ...args) => this.newAbstract(fqn, scope, id, ...args);
        root.typeForFqn = fqn => this.typeForFqn(fqn);

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