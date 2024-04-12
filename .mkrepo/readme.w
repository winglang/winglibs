bring fs;
bring "./library.w" as l;

pub class Util {
  extern "./util.js" static arraySlice(arr: Array<str>, start: num, end: num): MutArray<str>;

  pub static update(libraries: Array<l.Library>) {
    let readme = fs.readFile("README.md");
    let lines = readme.split("\n");

    let start = lines.indexOf("<!-- WINGLIBS_TOC_START -->");
    let end = lines.indexOf("<!-- WINGLIBS_TOC_END -->");

    if (start == -1 || end == -1) {
      throw "Could not find WINGLIBS_TOC_START or WINGLIBS_TOC_END in README.md";
    }

    let newLines = Util.arraySlice(lines, 0, start + 1);
    newLines.push("");
    newLines.push("| Library | npm package | Platforms |");
    newLines.push("| --- | --- | --- |");
    for lib in libraries {
      let var line = "| [{lib.name}](./{lib.dir})";
      line += " | [@winglibs/{lib.name}](https://www.npmjs.com/package/@winglibs/{lib.name})";
      let pkg = lib.manifest;      
      line += " | " + lib.platforms.join(", ") + " |";
      newLines.push(line);
    }
    newLines.push("");
    newLines.push("_Generated with `mkrepo.sh`. To update the list of supported platforms for a winglib, please update the \"wing\" section in its package.json file._");
    newLines.push("");
    let finalLines = newLines.concat(Util.arraySlice(lines, end, lines.length));

    fs.writeFile("README.md", finalLines.join("\n"));
  }
}
