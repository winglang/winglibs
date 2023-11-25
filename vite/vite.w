bring cloud;
bring sim;
bring util;
bring fs;
bring "./find-port.w" as find_port;

struct SimViteProps {
  root: str;
  env: Map<str>;
  cli: str;
  generateTypeDefinitions: bool;
}

class SimVite {
	pub url: str;

	new(props: SimViteProps) {
		let port = new find_port.Port();

		this.url = "http://localhost:${port.port}";

    new cloud.Service(inflight () => {
      SimVite.dev(props, port.port);
    });
	}

  extern "./vite.cjs" static inflight dev(options: SimViteProps, port: str): void; }


struct TfawsViteProps {
  root: str;
  env: Map<str>;
  cacheDuration: duration;
  cli: str;
  generateTypeDefinitions: bool;
}

class TfawsVite {
  pub url: str;

  new(props: TfawsViteProps) {
    TfawsVite.build(props);

    let website = new cloud.Website(
      path: "${props.root}/dist",
    );

    this.url = website.url;

    let distribution = unsafeCast(std.Node.of(website).findChild("Distribution"));

    // Fallback to `/index.html`.
    distribution?.addOverride("custom_error_response", [
      {
        error_code: 403,
        response_code: 200,
        response_page_path: "/index.html",
      },
    ]);

    // Set a short default TTL.
    distribution?.addOverride("default_cache_behavior.default_ttl", props.cacheDuration.seconds);
    distribution?.addOverride("default_cache_behavior.min_ttl", props.cacheDuration.seconds);

    // Cache assets forever.
    distribution?.addOverride("ordered_cache_behavior", {
      path_pattern: "/assets/*",
      allowed_methods: ["GET", "HEAD"],
      cached_methods: ["GET", "HEAD"],
      target_origin_id: "s3Origin",
      // See https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html#managed-cache-caching-optimized.
      cache_policy_id: "658327ea-f89d-4fab-a63d-7e88639e58f6",
      min_ttl: 1y.seconds,
      default_ttl: 1y.seconds,
      max_ttl: 1y.seconds,
      compress: true,
      viewer_protocol_policy: "redirect-to-https",
    });

    this.url = website.url;
  }

  extern "./vite.cjs" static build(options: TfawsViteProps): void;
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
    let env = Vite.mergeEnv(props.env ?? {});
    let cacheDuration = props.cacheDuration ?? 5m;
    let cli = Vite.cli();
    let generateTypeDefinitions = props.generateTypeDefinitions ?? false;

    let target = util.env("WING_TARGET");
    if target == "sim" {
			let implementation = new SimVite(
        root: props.root,
        env: env,
        cli: cli,
        generateTypeDefinitions: generateTypeDefinitions,
      );
			this.url = implementation.url;
		} elif target == "tf-aws" {
      let implementation = new TfawsVite(
        root: props.root,
        env: env,
        cacheDuration: cacheDuration,
        cli: cli,
        generateTypeDefinitions: generateTypeDefinitions,
      );
      this.url = implementation.url;
    } else {
      throw "Unsupported WING_TARGET ${target}";
    }
  }

  static mergeEnv(env: Map<str>): Map<str> {
    let commonEnv = MutMap<str>{
			"HOME" => util.env("HOME"),
			"PATH" => util.env("PATH"),
		};

    for key in env.keys() {
      commonEnv.set(key, env.get(key));
    }

    return commonEnv.copy();
  }

  extern "./vite.cjs" static cli(): str;
}
