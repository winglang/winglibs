bring fs;

struct PackageManifest {
  name: str;
  wing: WingOptions?;
}

struct WingOptions {
  platforms: Array<str>?;
}

pub class Library {
  extern "./util.js" static sortedArray(arr: Array<str>): Array<str>;

  pub name: str;
  pub dir: str; // relative to root of the repo
  pub platforms: Array<str>;
  pub buildJob: str;
  pub manifest: PackageManifest; // package.json

  new(workflowdir: str, libdir: str) {
    this.dir = libdir;
    this.name = fs.basename(libdir);
    let pkgjsonpath = "{libdir}/package.json";
    let pkgjson = fs.readJson(pkgjsonpath);
    this.manifest = PackageManifest.fromJson(pkgjson);

    log(this.manifest.name);
    this.buildJob = "build-{this.name}";
    let expected = "@winglibs/{this.name}";
    if this.manifest.name != expected {
      throw "'name' in {pkgjsonpath} is expected to be {expected}";
    }

    
    this.platforms = Library.sortedArray(this.manifest.wing?.platforms ?? []);
    if this.platforms.length == 0 {
      throw "\"{this.name}\" winglib does not have a `wing.platforms` field in its package.json.";
    }

    let addCommonSteps = (steps: MutArray<Json>) => {
      let var testCommand = "wing test";

      if (fs.exists("./{libdir}/test.sh")) {
        testCommand = fs.readFile("./{libdir}/test.sh", { encoding: "utf-8" });
      }

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
          "node-version": "20.x",
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
        run: testCommand,
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

    let tagName = "{this.name}-v\$\{\{ env.WINGLIB_VERSION \}\}";
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
        name: "{this.name} v\$\{\{ env.WINGLIB_VERSION \}\}",
        tag_name: tagName,
        files: "*.tgz",
        token: githubTokenWithAuth,
      },
    });

    let releaseJobs = MutJson {};
    releaseJobs.set(this.buildJob, {
      "runs-on": "ubuntu-latest",
      steps: releaseSteps.copy(),
    });
    fs.writeYaml("{workflowdir}/{this.name}-release.yaml", {
      name: "{this.name}-release",
      on: {
        push: {
          branches: ["main"],
          paths: [
            "{libdir}/**",
            "!{libdir}/package-lock.json"
          ],
        }
      },
      jobs: Json.deepCopy(releaseJobs),
    });

    let pullJobs = MutJson {};

    pullJobs.set("build-{this.name}", {
      "runs-on": "ubuntu-latest",
      steps: pullSteps.copy(),
    });

    fs.writeYaml("{workflowdir}/{this.name}-pull.yaml", {
      name: "{this.name}-pull",
      on: {
        pull_request: {
          paths: ["{libdir}/**"],
        }
      },
      jobs: Json.deepCopy(pullJobs),
    });
  }
}
