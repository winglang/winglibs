bring cloud;
bring fs;
bring sim;
bring util;

bring "./api.w" as api;
bring "./utils.w" as utils;

pub class AppSim extends api.AppBase impl api.IApp {
  pub url: str;

  new(props: api.AppProps) {
    super(props);

    let state = new sim.State();

    this.url = state.token("url");

    let service = new cloud.Service(inflight () => {
      let port = props.localPort ?? 3001;

      state.set("url", "http://localhost:{port}");

      fs.writeFile(
        fs.join(this.path, "public", "wing.js"),
        "// This file is generated by wing\nwindow.wingEnv = {Json.stringify(this.env)};",
      );

      let env = this.env.copyMut();
      env.set("PORT", "{port}");

      if this.props.useBuildCommand == true {
        util.shell(this.buildCommand, env: env.copy(), cwd: this.path, inheritEnv: true);

        return utils.Utils.serveStaticFiles(this.buildDir, port);
      }

      return utils.Utils.exec(this.startCommand, env, this.path);
    });

    service.addEnvironment("HOME", util.env("HOME"));
    service.addEnvironment("PATH", util.env("PATH"));

    nodeof(this).hidden = true;
  }

  pub getUrl(): str {
    return this.url;
  }
}
