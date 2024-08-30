bring fs;
bring "./canary.w" as canary;
bring "./gitattributes.w" as gitattributes;
bring "./library.w" as l;
bring "./mergify.w" as mergify;
bring "./pr-lint.w" as prlint;
bring "./check-config.w" as checkconfig;
bring "./stale.w" as stale;
bring "./readme.w" as readme;

let workflowdir = ".github/workflows";
let skippedLibrariesPath = "SKIPPED_LIBRARIES.json";

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

readme.update(libs.copy());

new stale.StaleWorkflow(workflowdir);
new mergify.MergifyWorkflow(libs.copy());
new checkconfig.CheckConfigWorkflow(workflowdir);
new prlint.PullRequestLintWorkflow(workflowdir, libs.copy());
new gitattributes.GitAttributes();

struct SkippedLibrary {
  name: str;
  reason: str;
}

let skippedLibrariesData: Array<SkippedLibrary> = unsafeCast(fs.readJson(skippedLibrariesPath)["skipped-packages"]);
let skippedLibraries = MutArray<str>[];
for item in skippedLibrariesData {
  skippedLibraries.push(item.name);
}
log("Libraries skipped for end-to-end tests: {Json.stringify(skippedLibraries)}");

new canary.CanaryWorkflow(workflowdir, libs.copy(), skippedLibraries.copy());
