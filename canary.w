bring fs;

pub class CanaryWorkflow {
  new(workflowdir: str, libs: Array<str>, skipLibs: Array<str>?) {
    let testLibSteps = (lib: str): Array<Json> => {
      let var testCommand = "wing test";

      if fs.exists("./{lib}/test.sh") {
        testCommand = fs.readFile("./{lib}/test.sh", { encoding: "utf-8" });
      }

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
            "node-version": "20.x",
            "registry-url": "https://registry.npmjs.org",
          },
        },
        {
          name: "Install winglang and dependencies",
          uses: "nick-fields/retry@v3",
          with: {
            max_attempts: 3,
            command: "npm i -g winglang --loglevel verbose",
            timeout_minutes: 3,
          },
        },
        {
          name: "Install dependencies",
          uses: "nick-fields/retry@v3",
          with: {
            max_attempts: 3,
            command: "cd {lib} && npm i --include=dev --loglevel verbose",
            timeout_minutes: 3,
          },
        },
        {
          name: "Run tests",
          uses: "nick-fields/retry@v3",
          with: {
            max_attempts: 3,
            command: "cd {lib}\n{testCommand}",
            timeout_minutes: 5,
          },
        },
      ];
    };

    let jobs = MutJson {};
    for lib in libs {
      if (skipLibs ?? []).contains(lib) {
        continue;
      }
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
        workflow_dispatch: {},
      },
      jobs: Json.deepCopy(jobs),
    });
  }
}
