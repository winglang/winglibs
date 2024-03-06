bring fs;

pub class MergifyWorkflow {
  new(libs: Array<str>) {
    let buildChecks = MutArray<Json>[];
    buildChecks.push("check-success=Validate PR title");
    for lib in libs {
      buildChecks.push("-check-failure=build-{lib}");
      buildChecks.push("-check-pending=build-{lib}");
      buildChecks.push("-check-stale=build-{lib}");
    }

    fs.writeYaml(".mergify.yml", {
      "queue_rules": [
        {
          "name": "default",
          "speculative_checks": 2,
          "conditions": [
            "-files=.mergify.yml",
          ]
        }
      ],
      "pull_request_rules": [
        {
          "name": "automatic merge",
          "actions": {
            "comment": {
              "message": "Thanks for contributing, @\{\{author\}\}! This PR will now be added to the [merge queue](https://mergify.com/merge-queue), or immediately merged if `\{\{head\}\}` is up-to-date with `\{\{base\}\}` and the queue is empty.\n"
            },
            "queue": {
              "name": "default",
              "method": "squash",
              "commit_message_template": "\{\{ title \}\} (#\{\{ number \}\})\n\{\{ body \}\}"
            }
          },
          "conditions": Array<Json>[
            "-files=.mergify.yml",
            "-title~=(?i)wip",
            "-label~=(🚧 pr/do-not-merge|⚠️ pr/review-mutation)",
            "-merged",
            "-closed",
            "-draft",
            "branch-protection-review-decision=APPROVED",
            "#approved-reviews-by>=1",
            "#changes-requested-reviews-by=0",
            "#review-threads-unresolved=0",
            "-approved-reviews-by~=author",
            "check-success=Validate PR title",
            "base=main",
          ].concat(buildChecks.copy())
        },
        {
          "name": "requires manual merge",
          "conditions": Array<Json>[
            "files=.mergify.yml",
            "-title~=(?i)wip",
            "-label~=(🚧 pr/do-not-merge|⚠️ pr/review-mutation|⚠️ mergify/review-config)",
            "-merged",
            "-closed",
            "-draft",
            "#approved-reviews-by>=1",
            "#changes-requested-reviews-by=0",
            "#review-threads-unresolved=0",
            "-approved-reviews-by~=author",
            "base=main"
          ].concat(buildChecks.copy()),
          "actions": {
            "comment": {
              "message": "Thank you for contributing! Your pull request contains mergify configuration changes and needs manual merge from a maintainer (be sure to [allow changes to be pushed to your fork](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/allowing-changes-to-a-pull-request-branch-created-from-a-fork))."
            },
            "label": {
              "add": [
                "⚠️ mergify/review-config"
              ]
            },
          }
        }
      ]
    });
  }
}
