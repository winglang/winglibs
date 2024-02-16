bring fs;
bring "./canary.w" as canary;
bring "./library.w" as l;
bring "./mergify.w" as mergify;
bring "./pr-lint.w" as prlint;
bring "./stale.w" as stale;

let workflowdir = ".github/workflows";

// clean up
fs.remove(workflowdir);
fs.mkdir(workflowdir);

let libs = MutArray<str>[];

for file in fs.readdir(".") {
  if !fs.exists("{file}/package.json") {
    log("skipping {file}");
    continue;
  }

  new l.Library(workflowdir, file) as file;
  libs.push(file);
}

new stale.StaleWorkflow(workflowdir);
new mergify.MergifyWorkflow(libs.copy());
new prlint.PullRequestLintWorkflow(workflowdir);
new canary.CanaryWorkflow(workflowdir, libs.copy());
