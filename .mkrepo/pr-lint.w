bring fs;
bring "./library.w" as l;

pub class PullRequestLintWorkflow {
  new(workflowdir: str, libs: Array<l.Library>) {
    let var types = MutArray<str>[
      "feat",
      "fix",
      "docs",
      "chore",
      "rfc",
      "revert",
    ];

    let names = MutArray<str>[];
    for l in libs {
      names.push(l.name);
    }

    types = types.concat(names);

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
                "types": types.join("\n"),
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
