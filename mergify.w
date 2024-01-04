bring fs;

pub class MergifyWorkflow {
  new() {
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
          "conditions": [
            "-files=.mergify.yml",
            "-title~=(?i)wip",
            "-label~=(🚧 pr/do-not-merge|⚠️ pr/review-mutation)",
            "-merged",
            "-closed",
            "branch-protection-review-decision=APPROVED",
            "#approved-reviews-by>=1",
            "#changes-requested-reviews-by=0",
            "#review-threads-unresolved=0",
            "-approved-reviews-by~=author",
            "check-success=Validate PR title",
            "check-success=build",
            "base=main",
          ]
        },
        {
          "name": "requires manual merge",
          "conditions": [
            "files=.mergify.yml",
            "-title~=(?i)wip",
            "-label~=(🚧 pr/do-not-merge|⚠️ pr/review-mutation|⚠️ mergify/review-config)",
            "-merged",
            "-closed",
            "#approved-reviews-by>=1",
            "#changes-requested-reviews-by=0",
            "#review-threads-unresolved=0",
            "-approved-reviews-by~=author",
            "check-success=Validate PR title",
            "check-success=build",
            "base=main"
          ],
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
