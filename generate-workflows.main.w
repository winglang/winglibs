bring fs;
bring "./library.w" as l;
bring "./stale.w" as stale;
bring "./mergify.w" as mergify;
bring "./pr-lint.w" as prlint;

// clean up
let workflowdir = ".github/workflows";
fs.remove(".github/workflows");
fs.mkdir(".github/workflows");

for file in fs.readdir(".") {
  if !fs.exists("{file}/package.json") {
    log("skipping {file}");
    continue;
  }

  new l.Library(workflowdir, file) as file;
}

new stale.StaleWorkflow(workflowdir);
new mergify.MergifyWorkflow();
new prlint.PullRequestLintWorkflow(workflowdir);
