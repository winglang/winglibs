bring cloud;
bring fs;

bring "./utils.w" as utils;

pub struct AppPros {
  projectPath: str;
  localPort: num?;
  buildDir: str?;
  startCommand: str?;
  buildCommand: str?;
  useBuildCommand: bool?;
}

pub interface IApp {
  getUrl(): str;
  addEnvironment(key: str, value: str): void;
}

pub class AppBase {
  protected props: AppPros;

  protected path: str;

  protected env: MutMap<str>;

  protected startCommand: str;
  protected buildCommand: str;
  protected buildDir: str;

  new(props: AppPros) {
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
