bring fs;

pub class PullRequestLintWorkflow {
  new(workflowdir: str) {
    fs.writeYaml("{workflowdir}/pull-request-lint.yaml", {
      name: "Pull Request Lint",
      on: {
        pull_request_target: {
          types: ["opened", "synchronize", "reopened", "edited"],
          "branches-ignore": ["mergify/merge-queue/*"],
        },
      },
      "jobs": {
        "validate": {
          "name": "Validate PR title",
          "runs-on": "ubuntu-latest",
          "steps": [
            {
              "uses": "amannn/action-semantic-pull-request@v5.2.0",
              "env": {
                "GITHUB_TOKEN": "$\{\{ secrets.GITHUB_TOKEN \}\}"
              },
              "with": {
                "types": "feat\nfix\ndocs\nchore\nrfc\nrevert",
                "subjectPattern": "^[^A-Z][^:]+[^.]$",
                "subjectPatternError": "Subject must start with a lowercase, should not include ':' and should not end with a period",
                "requireScope": false
              }
            }
          ]
        }
      }
    });
  }
}
