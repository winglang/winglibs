bring fs;

struct PackageManifest {
  name: str;
}

pub class Library {
  new(dir: str) {
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

    let addCommonSteps = (steps: MutArray<Json>) => {
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
        run: "wing test **/*.test.w",
        "working-directory": dir,
      });
    };

    let releaseSteps = MutArray<Json>[];
    let pullSteps = MutArray<Json>[];

    addCommonSteps(pullSteps);

    addCommonSteps(releaseSteps);

    releaseSteps.push({
      name: "Pack",
      run: "wing pack",
      "working-directory": dir,
    });

    releaseSteps.push({
      name: "Publish",
      run: "npm publish --access=public --registry https://registry.npmjs.org --tag latest *.tgz",
      "working-directory": dir,
      env: {
        NODE_AUTH_TOKEN: "\${{ secrets.NPM_TOKEN }}"
      } 
    });

    fs.writeYaml("${workflowdir}/${base}-release.yaml", { 
      name: "${base}-release",
      on: {
        push: {
          branches: ["main"],
          paths: ["${dir}/**"]
        }
      },
      jobs: {
        build: {
          "runs-on": "ubuntu-latest",
          steps: releaseSteps.copy()
        }
      }
    });

    fs.writeYaml("${workflowdir}/${base}-pull.yaml", { 
      name: "${base}-pull",
      on: {
        pull_request: {
          paths: ["${dir}/**"]
        }
      },
      jobs: {
        build: {
          "runs-on": "ubuntu-latest",
          steps: pullSteps.copy()
        }
      }
    });

  }
}
