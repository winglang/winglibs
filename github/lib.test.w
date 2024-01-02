bring expect;
bring util;
bring cloud;
bring "./probot/probot.w" as probot;

let handler = inflight (ctx) => {
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
let appId = new cloud.Secret(name:"github.app_id") as "appId";
let privateKey = new cloud.Secret(name:"gitub.app_key") as "privateKey";
let webhookSecret = new cloud.Secret(name:"github.webhook_secret") as "webhookSecret";


let markdown = new probot.ProbotApp(
  appId: appId,
  privateKey: privateKey,
  webhookSecret: webhookSecret,
  onPullRequestOpened: handler,
  onPullRequestReopened: handler
);


