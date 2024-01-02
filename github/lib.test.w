bring fs;
bring expect;
bring util;
bring "./probot/probot.w" as probot;
let key = fs.readFile("/path/to/private-key.pem");

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
    fs.writeFile("/tmp/113", "{Json.stringify(commitContent)}");
    if let files = commitContent.data.files {
      for file in files {
        fs.writeFile("/tmp/114", "{Json.stringify(file)}");
        if file.filename.endsWith(".md") && (file.status == "modified" || file.status == "added" || file.status == "changed") {
          mdFiles.set(file.filename, file.sha);
        }
      }
    }
  }
  fs.writeFile("/tmp/115", "{Json.stringify(mdFiles)}");

  // list over mdfiles and update them
  for filename in mdFiles.keys() {
    let contents = ctx.octokit.repos.getContent(
      owner: repo.owner.login,
      repo: repo.name,
      path: filename,
      ref: ctx.payload.pull_request.head.sha);
    
    let fileContents = util.base64Decode("{contents.data.content}");
      
      
    ctx.octokit.repos.createOrUpdateFileContents(
      owner: repo.owner.login,
      repo: repo.name,
      branch: ctx.payload.pull_request.head.ref,
      sha: contents.data.sha,
      path: filename,
      message: "uppercase {filename}",
      content: util.base64Encode(fileContents.lowercase())
    );
    fs.writeFile("/tmp/1115", fileContents.uppercase());
    
  }
};

let markdown = new probot.ProbotApp(
  appId: "<app-id>",
  privateKey: key,
  webhookSecret: "webhook-secret",
  onPullRequestOpened: handler,
  onPullRequestReopened: handler
);

test "add() adds two numbers" {
  
}
