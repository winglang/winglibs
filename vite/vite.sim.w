bring cloud;
bring sim;
bring util;
bring fs;
bring "./vite-types.w" as vite_types;

pub class Vite_sim {
  pub url: str;

  new(props: vite_types.ViteProps) {
    let state = new sim.State();
    this.url = state.token("url");

    let cliFilename = Vite_sim.cliFilename();
    let homeEnv = util.env("HOME");
    let pathEnv = util.env("PATH");

    new cloud.Service(inflight () => {
      let url = Vite_sim.dev({
        root: props.root,
        publicEnv: props.publicEnv ?? {},
        generateTypeDefinitions: props.generateTypeDefinitions ?? true,
        publicEnvName: props.publicEnvName ?? "wing",
        typeDefinitionsFilename: props.typeDefinitionsFilename ?? ".winglibs/wing-env.d.ts",
        cliFilename: cliFilename,
        homeEnv: homeEnv,
        pathEnv: pathEnv,
      });
      state.set("url", url);
    });
  }

  extern "./vite.cjs" static cliFilename(): str;
  extern "./vite.cjs" static inflight dev(options: Json): str;
}
