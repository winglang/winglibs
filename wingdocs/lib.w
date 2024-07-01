bring cloud;
bring util;
bring fs;

pub struct SiteProps {
  source: str;
  title: str;
}

pub class Site {
  website: cloud.Website;


  new(props: SiteProps) {
    let output = this.build_docs(props.source);

    log("source: {output}");

    this.website = new cloud.Website(path: output);
  }

  build_docs(source: str): str {
    let staging = fs.absolute("{nodeof(this).app.workdir}/../staging");

    log("Building docsite to {staging}..");
    
    Site.shell("{@dirname}/build-docs.sh", {
      DOCS_SOURCE: source,
      STAGING_DIR: staging,
      WING_DIRNAME: @dirname,
    });

    return "{staging}/build";
  }

  extern "./lib.ts" static shell(cmd: str, env: Map<str>): void;
}
