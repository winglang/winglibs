bring fs;

struct PackageManifest {
  name: str;
}

pub class Library {
  init(dir: str) {
    let pkgjsonpath = "${dir}/package.json";
    let pkgjson = fs.readJson(pkgjsonpath);
    let manifest = PackageManifest.fromJson(pkgjson);
    log(manifest.name);
    let base = fs.basename(dir);
    let expected = "@winglibs/${base}";
    if manifest.name != expected {
      throw "'name' in ${pkgjsonpath} is expected to be ${expected}";
    }

    let workflowdir = ".github/workflows";
    fs.mkdir(workflowdir);
    let steps = MutArray<Json>[];

    steps.push({
      name: "Checkout",
      uses: "actions/checkout@v3",
      with: {
        "sparse-checkout": dir
      }
    });

    steps.push({
      name: "Setup Node.js",
      uses: "actions/setup-node@v3",
      with: {
        "node-version": "18.x",
        "registry-url": "https://registry.npmjs.org",
      },
    });

    steps.push({
      name: "Install winglang",
      run: "npm i -g winglang",
    });

    steps.push({
      name: "Install dependencies",
      run: "npm install",
      "working-directory": dir,
    });

    steps.push({
      name: "Test",
      run: "wing test",
      "working-directory": dir,
    });

    steps.push({
      name: "Pack",
      run: "wing pack",
      "working-directory": dir,
    });

    steps.push({
      name: "Publish",
      run: "npm publish *.tgz",
      "working-directory": dir,
      env: {
        NODE_AUTH_TOKEN: "\${{ secrets.NPM_TOKEN }}"
      } 
    });

    fs.writeYaml("${workflowdir}/${base}.yaml", { 
      name: base,
      on: ["push"],
      jobs: {
        build: {
          "runs-on": "ubuntu-latest",
          steps: steps.copy()
        }
      }
    });
  }
}
