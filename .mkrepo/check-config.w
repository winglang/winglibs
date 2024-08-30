bring fs;

/// Create a workflow that runs mkrepo.sh to generate any config files
/// for the monorepo, and detect if any changes are detected.
/// This makes sure that the CI fails if any config files are out of date
/// or if they're manually edited by accident.
pub class CheckConfigWorkflow {
  new(workflowdir: str) {
    fs.writeYaml("{workflowdir}/check-config.yaml", {
      name: "Check Config Files",
      on: {
        pull_request: {}
      },
      "jobs": {
        "check-mutation": {
          "name": "Check for mutations",
          "runs-on": "ubuntu-latest",
          "steps": [
            {
              "uses": "actions/checkout@v3",
            },
            {
              "uses": "actions/setup-node@v3",
              "with": {
                "node-version": "20.x",
                "registry-url": "https://registry.npmjs.org",
              },
            },
            {
              "name": "Install winglang",
              "run": "npm i -g winglang",
            },
            {
              "name": "Generate config files",
              "run": "./mkrepo.sh",
            },
            {
              "name": "Check for missing changes",
              "run": "git diff --exit-code || (echo 'Please run \"./mkrepo.sh\" from the root of the repository, and commit any changes to your branch.' && exit 1)",
            },
          ],
        },
      }
    });
  }
}
