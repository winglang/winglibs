bring fs;
bring "./canary.w" as canary;
bring "./gitattributes.w" as gitattributes;
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

let libs = MutArray<l.Library>[];

for file in fs.readdir(".") {
  if file.startsWith(".") {
    continue;
  }

  if !fs.exists("{file}/package.json") {
    continue;
  }

  let lib = new l.Library(workflowdir, file) as file;
  libs.push(lib);
}

try {
  readme.update(libs.copy());
} catch e {
  log(e);
}

new stale.StaleWorkflow(workflowdir);
new mergify.MergifyWorkflow(libs.copy());
new prdiff.PullRequestDiffWorkflow(workflowdir);
new prlint.PullRequestLintWorkflow(workflowdir, libs.copy());
new gitattributes.GitAttributes();

let skipCanaryTests = [
  "containers" // https://github.com/winglang/wing/issues/5716
];

new canary.CanaryWorkflow(workflowdir, libs.copy(), skipCanaryTests);
