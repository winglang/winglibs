bring cloud;
bring sim;
bring util;
bring fs;
bring "./vite-types.w" as vite_types;

inflight interface DevOutput {
  inflight url(): str;
  inflight kill(): void;
}

pub class Vite_sim {
  pub url: str;

  new(props: vite_types.ViteProps) {
    let state = new sim.State();
    this.url = state.token("url");

    let cliFilename = Vite_sim.cliFilename();
    let homeEnv = util.tryEnv("HOME") ?? "";
    let pathEnv = util.tryEnv("PATH") ?? "";
    let openBrowser = util.env("WING_IS_TEST") != "true";

    new cloud.Service(inflight () => {
      let output = Vite_sim.dev({
        root: props.root,
        publicEnv: props.publicEnv ?? {},
        generateTypeDefinitions: props.generateTypeDefinitions ?? true,
        publicEnvName: props.publicEnvName ?? "wing",
        typeDefinitionsFilename: props.typeDefinitionsFilename ?? ".winglibs/wing-env.d.ts",
        cliFilename: cliFilename,
        homeEnv: homeEnv,
        pathEnv: pathEnv,
        openBrowser: openBrowser,
      });
      state.set("url", output.url());
      return () => {
        output.kill();
      };
    });
  }

  extern "./vite.cjs" static cliFilename(): str;
  extern "./vite.cjs" static inflight dev(options: Json): DevOutput;
}
