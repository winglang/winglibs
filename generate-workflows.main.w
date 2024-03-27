bring fs;
bring "./canary.w" as canary;
bring "./library.w" as l;
bring "./mergify.w" as mergify;
bring "./pr-lint.w" as prlint;
bring "./pr-diff.w" as prdiff;
bring "./stale.w" as stale;
bring "./readme.w" as readme;

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

readme.update(libs.copy());

new stale.StaleWorkflow(workflowdir);
new mergify.MergifyWorkflow(libs.copy());
new prdiff.PullRequestDiffWorkflow(workflowdir);
new prlint.PullRequestLintWorkflow(workflowdir, libs.copy());

let skipCanaryTests = [
  "containers" // https://github.com/winglang/wing/issues/5716
];

new canary.CanaryWorkflow(workflowdir, libs.copy(), skipCanaryTests);
