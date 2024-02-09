bring fs;

pub class CanaryWorkflow {
  new(workflowdir: str, libs: Array<str>) {
    let testLibSteps = (lib: str): Array<Json> => {
      return [
        {
          name: "Checkout",
          uses: "actions/checkout@v3",
          with: {
            "sparse-checkout": lib
          }
        },
        {
          name: "Setup Node.js",
          uses: "actions/setup-node@v3",
          with: {
            "node-version": "18.x",
            "registry-url": "https://registry.npmjs.org",
          },
        },
        {
          name: "Install winglang",
          run: "npm i -g winglang",
        },
        {
          name: "Install dependencies",
          run: "npm install --include=dev",
          "working-directory": lib,
        },
        {
          name: "Test",
          run: "wing test",
          "working-directory": lib,
        },
      ];
    };

    let jobs = MutJson {};
    for lib in libs {
      jobs.set("canary-{lib}", {
        name: "Test {lib}",
        "runs-on": "ubuntu-latest",
        steps: testLibSteps(lib),
      });
    }

    fs.writeYaml("{workflowdir}/canary.yaml", {
      name: "Canary Workflow",
      on: {
        schedule: [{
          cron: "0 * * * *"
        }],
      },
      jobs: Json.deepCopy(jobs),
    });
  }
}
