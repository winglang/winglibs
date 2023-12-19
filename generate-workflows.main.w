bring fs;
bring "./library.w" as l;
bring "./stale.w" as stale;

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

new stale.StaleBot(workflowdir);
