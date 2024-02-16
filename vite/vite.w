bring cloud;
bring sim;
bring util;
bring fs;

struct Vite_simProps {
  root: str;
  homeEnv: str;
  pathEnv: str;
  env: Map<str>?;
  cli: str;
  generateTypeDefinitions: bool;
}

class Vite_sim {
  pub url: str;

  new(props: Vite_simProps) {
    let state = new sim.State();
    this.url = state.token("url");

    new cloud.Service(inflight () => {
      let url = Vite_sim.dev(props);
      state.set("url", url);
    });
  }

  extern "./vite.cjs" static inflight dev(options: Vite_simProps): str;
}

struct Vite_tfawsProps {
  root: str;
  homeEnv: str;
  pathEnv: str;
  env: Map<str>?;
  cacheDuration: duration;
  cli: str;
  generateTypeDefinitions: bool;
}

class Vite_tfaws {
  pub url: str;

  new(props: Vite_tfawsProps) {
    let outDir = Vite_tfaws.build(props);
    let distDir = "{props.root}/{outDir}";

    let website = new cloud.Website(
      path: "{props.root}/{outDir}",
    );

    this.url = website.url;

    // let distribution = unsafeCast(std.Node.of(website).findChild("Distribution"));

    // // Fallback to `/index.html`.
    // distribution?.addOverride("custom_error_response", [
    //   {
    //     error_code: 403,
    //     response_code: 200,
    //     response_page_path: "/index.html",
    //   },
    // ]);

    // // Set a short default TTL.
    // distribution?.addOverride("default_cache_behavior.default_ttl", props.cacheDuration.seconds);
    // distribution?.addOverride("default_cache_behavior.min_ttl", props.cacheDuration.seconds);

    // // Cache assets forever.
    // distribution?.addOverride("ordered_cache_behavior", {
    //   path_pattern: "/assets/*",
    //   allowed_methods: ["GET", "HEAD"],
    //   cached_methods: ["GET", "HEAD"],
    //   target_origin_id: "s3Origin",
    //   // See https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html#managed-cache-caching-optimized.
    //   cache_policy_id: "658327ea-f89d-4fab-a63d-7e88639e58f6",
    //   min_ttl: 1y.seconds,
    //   default_ttl: 1y.seconds,
    //   max_ttl: 1y.seconds,
    //   compress: true,
    //   viewer_protocol_policy: "redirect-to-https",
    // });
  }

  extern "./vite.cjs" static build(options: Vite_tfawsProps): str;
}

pub struct ViteProps {
  root: str;
  env: Map<str>?;
  cacheDuration: duration?;
  generateTypeDefinitions: bool?;
}

pub class Vite {
  pub url: str;

  new(props: ViteProps) {
    let cacheDuration = props.cacheDuration ?? 5m;
    let cli = Vite.cli();
    let generateTypeDefinitions = props.generateTypeDefinitions ?? false;

    let target = util.env("WING_TARGET");
    if target == "sim" {
      let implementation = new Vite_sim(
        root: props.root,
        homeEnv: util.env("HOME"),
        pathEnv: util.env("PATH"),
        env: props.env,
        cli: cli,
        generateTypeDefinitions: generateTypeDefinitions,
      );
      this.url = implementation.url;
    } elif target == "tf-aws" {
      let implementation = new Vite_tfaws(
        root: props.root,
        homeEnv: util.env("HOME"),
        pathEnv: util.env("PATH"),
        env: props.env,
        cacheDuration: cacheDuration,
        cli: cli,
        generateTypeDefinitions: generateTypeDefinitions,
      );
      this.url = implementation.url;
    } else {
      throw "Unsupported WING_TARGET ${target}";
    }
  }

  extern "./vite.cjs" static cli(): str;
}
