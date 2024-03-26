bring fs;

pub class Util {
  extern "./util.js" static arraySlice(arr: Array<str>, start: num, end: num): MutArray<str>;
  extern "./util.js" static arraySort(arr: MutArray<str>): void;

  pub static update(libraries: Array<str>) {
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
      let var line = "| [{lib}](./{lib})";
      line += " | [@winglibs/{lib}](https://www.npmjs.com/package/@winglibs/{lib})";
      let pkgJson = fs.readFile("{lib}/package.json");
      let pkg = Json.parse(pkgJson);
      let platforms: MutArray<str> = unsafeCast(pkg.tryGet("wing")?.tryGet("platforms")) ?? [];
      if platforms.length == 0 {
        throw "\"{lib}\" winglib does not have a `wing.platforms` field in its package.json.";
      }
      Util.arraySort(platforms);
      line += " | " + platforms.join(", ") + " |";
      newLines.push(line);
    }
    newLines.push("");
    newLines.push("_Generated with `wing compile generate-workflows.w`. To update the list of supported platforms for a winglib, please update the \"wing\" section in its package.json file._");
    newLines.push("");
    let finalLines = newLines.concat(Util.arraySlice(lines, end, lines.length));

    fs.writeFile("README.md", finalLines.join("\n"));
  }
}
