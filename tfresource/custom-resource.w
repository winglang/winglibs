bring "cdktf" as cdktf;
bring fs;
bring cloud;
bring util;

pub class TerraformResource {
  commands: MutJson;

  new() {
    this.setupProvider();

    this.commands = {};

    class Shell extends cdktf.TerraformResource {
      c: MutJson;

      new(commands: MutJson) {
        super(terraformResourceType: "shell_script");
        this.c = commands;
      }

      pub synthesizeAttributes(): Json {
        return {
          lifecycle_commands: Json.deepCopy(this.c),
        };
      }
    }

    new Shell(this.commands);
  }

  pub onCreate(handler: inflight (): Json) {
    let prog = this.toExecutable("create", handler);
    this.commands.set("create", "node {prog}");
  }

  pub onRead(handler: inflight (Json): Json) {
    let prog = this.toExecutable("read", handler);
    this.commands.set("read", "node {prog}");
  }

  pub onUpdate(handler: inflight (Json): Json) {
    let prog = this.toExecutable("update", handler);
    this.commands.set("update", "node {prog}");
  }

  pub onDelete(handler: inflight (Json): Json?) {
    let prog = this.toExecutable("delete", handler);
    this.commands.set("delete", "node {prog}");
  }

  toExecutable(name: str, handler: inflight (Json): Json?): str {
    let workdir = std.Node.of(this).app.workdir;
    let code: str = unsafeCast(handler)?._toInflight();

    let path = fs.join(workdir, "{name}-{this.node.addr}.js");
    let wrapper = "
      const fs = require('fs');
      const data = fs.readFileSync(0, 'utf-8');
      const input = data ? JSON.parse(data) : \{};
      console.log = console.error;
      const invoke = async () => ({code}).handle(input);
      invoke().then(output => \{
        output = output ?? \{};
        process.stdout.write(JSON.stringify(output));
      }).catch(e => \{
        console.error(e);
        process.exit(1);
      });
    ";
    fs.writeFile(path, wrapper);
    return fs.relative(fs.dirname(fs.absolute(workdir)), path);
  }

  setupProvider() {
    let uid = "TerraformProvider:scottwinkler-shell";
    let root = std.Node.of(this).root;
    let rootNode = std.Node.of(root);

    if rootNode.tryFindChild(uid)? {
      // already installed
      return;
    }

    class ShellProvider extends cdktf.TerraformProvider {
      new() {
        super(
          terraformResourceType: "shell",
          terraformProviderSource: "scottwinkler/shell",
          terraformGeneratorMetadata: {
            providerName: "shell",
            providerVersion: "1.7.10",
            providerVersionConstraint: "~> 1.0"
          },
        );
      }
    }
    
    new ShellProvider() as uid in root;
  }
}
