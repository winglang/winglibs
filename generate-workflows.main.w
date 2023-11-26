bring fs;
bring "./library.w" as l;

// clean up
fs.remove(".github/workflows");

for file in fs.readdir(".") {
  if !fs.exists("{file}/package.json") {
    log("skipping {file}");
    continue;
  }

  new l.Library(file) as file;
}

