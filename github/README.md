# github

A Wing library for working with [GitHub Probot](https://github.com/probot/probot)


## Prerequisites

* [winglang](https://winglang.io).
* [Install ngrok](https://ngrok.com/docs/getting-started/)


## Installation

`sh
npm i @winglibs/github
`

## Usage

This following application is a simple GitHub application that listens to created and reopened 
pull requests, look for any `*.md` files that where changed and replace their content with their 
uppercase version. 

* It requires a GitHub application
* Configured secrets 

In order to start you need to create a GitHub application:

### Create a GitHub App

1. Goto https://github.com/settings/apps
2. Click "New GitHub App" and complete form
3. GitHub App Name
4. Homepage URL: e.g. https://winglang.io
5. Webhook:
   1. Active: ✅
   2. URL: http://this-will-change-automatically.com
   3. Webhook secret: "this-is-a-bad-secret"
6. Permissions -> Repository permissions:
   1. Contents: Read and write 
   2. Pull requests: Read and write
7. Subscribe to events
   1. Pull request
   2. Push
8. Save
9. Notice the app id and save it 
10. Generate & download a private key for the app 

### `main.w`

When running on the simulator, the Webhook URL will automatically update on every simulator run.

```js
bring util;
bring cloud;
bring github;
bring fs;

let uppercaseAllMarkdownFiles = inflight (ctx) => {
  let repo = ctx.payload.repository;

  // find all changed mdfiles by comparing the commits of the PR
  let compare = ctx.octokit.repos.compareCommits(
    owner: repo.owner.login,
    repo: repo.name,
    base: ctx.payload.pull_request.base.sha,
    head: ctx.payload.pull_request.head.sha,
  );

  let mdFiles = MutMap<str>{};
  for commit in compare.data.commits {
    let commitContent = ctx.octokit.repos.getCommit(
      owner: repo.owner.login,
      repo: repo.name,
      ref: ctx.payload.pull_request.head.ref,
    );
    if let files = commitContent.data.files {
      for file in files {
        if file.filename.endsWith(".md") &&
         (file.status == "modified" || file.status == "added" || file.status == "changed") {
          mdFiles.set(file.filename, file.sha);
        }
      }
    }
  }

  // list over mdfiles and update them
  for filename in mdFiles.keys() {
    let contents = ctx.octokit.repos.getContent(
      owner: repo.owner.login,
      repo: repo.name,
      path: filename,
      ref: ctx.payload.pull_request.head.sha
    );
    
    let fileContents = util.base64Decode("{contents.data.content}");
      
    ctx.octokit.repos.createOrUpdateFileContents(
      owner: repo.owner.login,
      repo: repo.name,
      branch: ctx.payload.pull_request.head.ref,
      sha: contents.data.sha,
      path: filename,
      message: "uppercase {filename}",
      content: util.base64Encode(fileContents.uppercase())
    );    
  }
};

class SimpleCredentialsSupplier impl github.IProbotAppCredentialsSupplier {
   
   pub inflight getId(): str {
    return "app id";
   }

   pub inflight getWebhookSecret(): str {
    return "this-is-a-bad-secret";
   }

   pub inflight getPrivateKey(): str {
    return fs.readFile("/path/to/private-key.pem");
   }
}

let credentialsSupplier = new SimpleCredentialsSupplier();
let markdown = new github.ProbotApp(
  credentialsSupplier: credentialsSupplier,
  onPullRequestOpened: handler,
  onPullRequestReopened: handler
);
```

## License

This library is licensed under the [MIT License](./LICENSE).
