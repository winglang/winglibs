bring cloud;
bring fs;

bring "./utils.w" as utils;

pub struct ReactAppPros {
  projectPath: str;
  localPort: num?;
  buildDir: str?;
  startCommand: str?;
  buildCommand: str?;
  useBuildCommand: bool?;
}

pub interface IReactApp {
  getUrl(): str;
  addEnvironment(key: str, value: str): void;
}

pub class ReactAppBase {
  protected props: ReactAppPros;

  protected path: str;

  protected env: MutMap<str>;

  protected startCommand: str;
  protected buildCommand: str;
  protected buildDir: str;

  new(props: ReactAppPros) {
    this.path = fs.absolute(nodeof(this).app.entrypointDir, props.projectPath);

    if !fs.exists(this.path) {
      throw "{this.path} not exists";
    }

    this.props = props;

    this.env = {};

    this.buildDir = fs.join(this.path, this.props.buildDir ?? "./build");

    this.startCommand = this.props.startCommand ?? "npm run start";
    this.buildCommand = this.props.buildCommand ?? "npm run build";
  }

  pub addEnvironment(key: str, value: str) {
    this.env.set(key, value);
  }
}
