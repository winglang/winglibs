bring fs;

pub class GitAttributes {
  new() {
    let lines = MutArray<str>[];
    lines.push("# Auto-generated by ./mkrepo.sh");
    lines.push("");
    lines.push("/.github/workflows/*-pull.yaml linguist-generated");
    lines.push("/.github/workflows/*-release.yaml linguist-generated");
    lines.push("/**/package-lock.json linguist-generated");
    lines.push("/**/*.extern.d.ts linguist-generated");
    lines.push("/package-lock.json linguist-generated");
    lines.push("");
    fs.writeFile(".gitattributes", lines.join("\n"));
  }
}
