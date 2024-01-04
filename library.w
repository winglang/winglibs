bring fs;

struct PackageManifest {
  name: str;
}

pub class Library {
  new(workflowdir: str, libdir: str) {
    let pkgjsonpath = "{libdir}/package.json";
    let pkgjson = fs.readJson(pkgjsonpath);
    let manifest = PackageManifest.fromJson(pkgjson);
    log(manifest.name);
    let base = fs.basename(libdir);
    let expected = "@winglibs/{base}";
    if manifest.name != expected {
      throw "'name' in {pkgjsonpath} is expected to be {expected}";
    }

    let addCommonSteps = (steps: MutArray<Json>) => {
      steps.push({
        name: "Checkout",
        uses: "actions/checkout@v3",
        with: {
          "sparse-checkout": libdir
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
        run: "npm install --include=dev",
        "working-directory": libdir,
      });
  
      steps.push({
        name: "Test",
        run: "wing test",
        "working-directory": libdir,
      });

      steps.push({
        name: "Pack",
        run: "wing pack",
        "working-directory": libdir,
      });
  
    };

    let releaseSteps = MutArray<Json>[];
    let pullSteps = MutArray<Json>[];

    addCommonSteps(pullSteps);
    addCommonSteps(releaseSteps);

    releaseSteps.push({
      name: "Get package version",
      run: "echo WINGLIB_VERSION=\$(node -p \"require('./package.json').version\") >> \"$GITHUB_ENV\"",
      "working-directory": libdir,
    });

    releaseSteps.push({
      name: "Publish",
      run: "npm publish --access=public --registry https://registry.npmjs.org --tag latest *.tgz",
      "working-directory": libdir,
      env: {
        NODE_AUTH_TOKEN: "\$\{\{ secrets.NPM_TOKEN }}"
      }
    });

    let tagName = "{base}-v\$\{\{ env.WINGLIB_VERSION \}\}";
    let githubTokenWithAuth = "\$\{\{ secrets.PROJEN_GITHUB_TOKEN }}";

    releaseSteps.push({
      name: "Tag commit",
      uses: "tvdias/github-tagger@v0.0.1",
      with: {
        "repo-token": githubTokenWithAuth,
        tag: tagName,
      }
    });

    releaseSteps.push({
      name: "GitHub release",
      uses: "softprops/action-gh-release@v1",
      with: {
        name: "{base} v\$\{\{ env.WINGLIB_VERSION \}\}",
        tag_name: tagName,
        files: "*.tgz",
        token: githubTokenWithAuth,
      },
    });

    let releaseJobs = MutJson {};
    releaseJobs.set("build-{base}", {
      "runs-on": "ubuntu-latest",
      steps: releaseSteps.copy(),
    });
    fs.writeYaml("{workflowdir}/{base}-release.yaml", { 
      name: "{base}-release",
      on: {
        push: {
          branches: ["main"],
          paths: ["{libdir}/**"]
        }
      },
      jobs: Json.deepCopy(releaseJobs),
    });

    let pullJobs = MutJson {};
    pullJobs.set("build-{base}", {
      "runs-on": "ubuntu-latest",
      steps: pullSteps.copy(),
    });
    fs.writeYaml("{workflowdir}/{base}-pull.yaml", {
      name: "{base}-pull",
      on: {
        pull_request: {
          paths: ["{libdir}/**"]
        }
      },
      jobs: Json.deepCopy(pullJobs),
    });
  }
}
