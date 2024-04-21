bring fs;

pub class StaleWorkflow {
  new(workflowdir: str) {
    let staleSteps = [
      {
        "uses": "actions/stale@v6",
        "with": {
          "days-before-issue-stale": -1,
          "days-before-pr-stale": 20,
          "stale-pr-message": "Hi,\n\nThis PR has not seen activity in 20 days. Therefore, we are marking the PR as stale for now. It will be closed after 7 days.\nIf you need help with the PR, do not hesitate to reach out in the winglang community slack at [winglang.slack.com](https://winglang.slack.com).\nFeel free to re-open this PR when it is still relevant and ready to be worked on again.\nThanks!",
        }
      }
    ];

    fs.writeYaml("{workflowdir}/close-stale.yaml", {
      name: "Close Stale PRs",
      on: {
        schedule: [
          {
            cron: "0 6 * * *"
          }
        ]
      },
      jobs: {
        stale: {
          name: "Closing stale PRs",
          "runs-on": "ubuntu-latest",
          permissions: {
            issues: "write",
            "pull-requests": "write"
          },
          steps: staleSteps
        }
      }
    });
  }
}
