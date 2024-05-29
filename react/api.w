bring cloud;
bring fs;

bring "./utils.w" as utils;

pub struct AppProps {
  // The path to the React app root folder - can be absolute or relative to the wing folder.
  projectPath: str;
  // A port to start a local build of the React app on.
  localPort: num?;
  // The path to the React app build folder - relative to the `projectPath`.
  buildDir: str?;
  // A command for starting React app locally.
  startCommand: str?;
  // A command for building the React app.
  buildCommand: str?;
  // In sim, if `true` - will use the start command, and if `false` - the build command.
  useBuildCommand: bool?;
  // The website's custom domain object.
  domain: cloud.Domain?;
}

pub interface IApp {
  getUrl(): str;
  addEnvironment(key: str, value: str): void;
}

pub class AppBase {
  protected props: AppProps;

  protected path: str;

  protected env: MutMap<str>;

  protected startCommand: str;
  protected buildCommand: str;
  protected buildDir: str;

  new(props: AppProps) {
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

  // Adding a key-value pair that can be accessible later via the `window.wingEnv` object in the react code.
  pub addEnvironment(key: str, value: str) {
    this.env.set(key, value);
  }
}
