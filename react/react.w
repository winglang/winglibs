bring cloud;
bring fs;
bring ui;
bring util;
bring "./util.w" as u;

pub struct ReactOptions {
  /**
   * The path to the React app build folder- relative to the `projectPath`
   * @default "./build"
   */

  buildDir: str?;

  /**
   * A command for building the React app
   * @default "npm run build"
   */
  buildCommand: str?;

  /**
   * A command for starting React app locally
   * @default "npm run start"
   */
  startCommand: str?;

  // /**
  //  * In sim, if `true` - will use the start command, and if `false` - the build command
  //  * @default false
  //  */
  // useBuildCommand: bool?;
  // /**
  //  * A port to start a local build of the React app on.
  //  * @default 3001
  //  */
  // localPort: num?;
}

pub struct ReactProps extends cloud.WebsiteDomainOptions, ReactOptions { }

pub class React {
  pub url: str;

  new(path: str, props: ReactProps?) {
    let app = std.Node.of(this).app;
    let buildCommand = props?.buildCommand ?? "npm run build";

    let projectPath = fs.absolute(std.Node.of(this).app.entrypointDir, path);
    let buildDir = props?.buildDir ?? "./build";

    
    let target = util.env("WING_TARGET");
    if target == "sim" {
      let buildPath = fs.join(app.workdir, "react-build");
      let startCommand = props?.startCommand ?? "PORT=3333 BROWSER=none BUILD_PATH={buildPath} npm run start";
      log(startCommand);
      new cloud.Service(inflight () => {
        let child = u.spawn(startCommand, cwd: projectPath);
        return () => {
          child.kill("SIGINT");
        };
      });

      this.url = "http://localhost:3333";
    } else {
      u.shell(buildCommand, cwd: projectPath, maxBuffer: 10 * 1024 * 1024);

      fs.remove(fs.join(projectPath, "wing.js"), force: true);
  
      let outdir = fs.join(projectPath, buildDir);
      let host = new cloud.Website(
        path: outdir,
        domain: props?.domain,
      );
  
      this.url = host.url;
    }
  }
}

