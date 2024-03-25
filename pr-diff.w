bring fs;

pub class PullRequestDiffWorkflow {
  new(workflowdir: str) {
    fs.writeYaml("{workflowdir}/pull-request-diff.yaml", {
      name: "Pull Request Diff",
      on: {
        pull_request_target: {
          types: ["opened", "synchronize", "reopened", "edited"],
          "branches-ignore": ["mergify/merge-queue/*"],
        },
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
              "name": "Update config files",
              "run": "wing compile generate-workflows.main.w",
            },
            {
              "name": "Check for missing changes",
              "run": "git diff --exit-code || (echo 'Please run \"wing compile generate-workflows.main.w\" from the root of the repository, and commit any changes to your branch.' && exit 1)",
            },
          ],
        },
      }
    });
  }
}