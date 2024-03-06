bring cloud;
bring util;
bring fs;
bring "cdktf" as cdktf;
bring "@cdktf/provider-aws" as aws;
bring "./vite-types.w" as vite_types;

class Util {
  extern "./util.cjs" pub static contentType(filename: str): str;
  pub static listAllFiles(directory: str, handler: (str): void, cwd: str?): void {
    let files = fs.readdir(directory);
    let cwdLength = (cwd ?? directory).length + 1;
    for file in files {
      let path = "{directory}/{file}";
      if (fs.isDir(path)) {
        Util.listAllFiles(path, handler, cwd ?? directory);
      } else {
        handler(path.substring(cwdLength));
      }
    }
  }
}

pub class Vite_tf_aws {
  pub url: str;

  new(props: vite_types.ViteProps) {
    let cliFilename = Vite_tf_aws.cliFilename();
    let homeEnv = util.env("HOME");
    let pathEnv = util.env("PATH");
    let outDir = Vite_tf_aws.build({
      root: props.root,
      publicEnv: props.publicEnv ?? {},
      generateTypeDefinitions: props.generateTypeDefinitions ?? true,
      publicEnvName: props.publicEnvName ?? "wing",
      typeDefinitionsFilename: props.typeDefinitionsFilename ?? ".winglibs/wing-env.d.ts",
      cliFilename: cliFilename,
      homeEnv: homeEnv,
      pathEnv: pathEnv,
    });
    let distDir = "{props.root}/{outDir}";

    let bucket = new cloud.Bucket();

    let terraformBucket: aws.s3Bucket.S3Bucket = unsafeCast(bucket.node.defaultChild);
    Util.listAllFiles(distDir, (file) => {
      let key = "/{file}";
      let filename = fs.absolute("{distDir}/{file}");
      let var cacheControl = "public, max-age={1m.seconds}";
      if key.startsWith("/assets/") {
        cacheControl = "public, max-age={1y.seconds}, immutable";
      }
      if file == "index.html" {
        new aws.s3Object.S3Object(
          dependsOn: [terraformBucket],
          key: key,
          bucket: terraformBucket.bucket,
          content: fs.readFile(filename),
          contentType: Util.contentType(filename),
          cacheControl: cacheControl,
        ) as "File{key.replace("/", "--")}";
      } else {
        new aws.s3Object.S3Object(
          dependsOn: [terraformBucket],
          key: key,
          bucket: terraformBucket.bucket,
          source: filename,
          sourceHash: cdktf.Fn.md5(filename),
          contentType: Util.contentType(filename),
          cacheControl: cacheControl,
        ) as "File{key.replace("/", "--")}";
      }
    });

    new aws.s3BucketWebsiteConfiguration.S3BucketWebsiteConfiguration(
      bucket: terraformBucket.bucket,
      indexDocument: {
        suffix: "index.html",
      },
      errorDocument: {
        key: "index.html",
      },
    );

    let originAccessControl = new aws.cloudfrontOriginAccessControl.CloudfrontOriginAccessControl(
      name: "{this.node.path.substring(0, 64 - 4)}-oac",
      originAccessControlOriginType: "s3",
      signingBehavior: "always",
      signingProtocol: "sigv4",
    );

    let distribution = new aws.cloudfrontDistribution.CloudfrontDistribution(
      enabled: true,
      defaultRootObject: "index.html",
      customErrorResponse: [
        {
          errorCode: 403,
          responseCode: 200,
          responsePagePath: "/index.html",
        },
        {
          errorCode: 404,
          responseCode: 200,
          responsePagePath: "/index.html",
        },
      ],
      origin: [
        {
          domainName: terraformBucket.bucketRegionalDomainName,
          originId: "s3Origin",
          originAccessControlId: originAccessControl.id,
        },
      ],
      defaultCacheBehavior: {
        allowedMethods: ["GET", "HEAD"],
        cachedMethods: ["GET", "HEAD"],
        targetOriginId: "s3Origin",
        forwardedValues: {
          queryString: false,
          cookies: { forward: "none" },
        },
        viewerProtocolPolicy: "redirect-to-https",
        compress: true,
        minTtl: 1m.seconds,
        defaultTtl: 1m.seconds,
        maxTtl: 1y.seconds,
      },
      priceClass: "PriceClass_100",
      restrictions: {
        geoRestriction: {
        restrictionType: "none",
        },
      },
      viewerCertificate: {
        cloudfrontDefaultCertificate: true,
      },
      orderedCacheBehavior: [
        {
          pathPattern: "/assets/*",
          allowedMethods: ["GET", "HEAD"],
          cachedMethods: ["GET", "HEAD"],
          targetOriginId: "s3Origin",
          // See https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html#managed-cache-caching-optimized.
          cachePolicyId: "658327ea-f89d-4fab-a63d-7e88639e58f6",
          compress: true,
          viewerProtocolPolicy: "redirect-to-https",
        },
      ],
    );

    let allowDistributionReadOnly = new aws.dataAwsIamPolicyDocument.DataAwsIamPolicyDocument(
      statement: [
        {
          actions: ["s3:GetObject"],
          condition: [
          {
            test: "StringEquals",
            values: [distribution.arn],
            variable: "AWS:SourceArn",
          },
          ],
          principals: [
          {
            identifiers: ["cloudfront.amazonaws.com"],
            type: "Service",
          },
          ],
          resources: ["{terraformBucket.arn}/*"],
        },
      ],
    );

    new aws.s3BucketPolicy.S3BucketPolicy({
      bucket: terraformBucket.id,
      policy: allowDistributionReadOnly.json,
    });

    this.url = "https://{distribution.domainName}";
  }

  extern "./vite.cjs" static cliFilename(): str;
  extern "./vite.cjs" static build(options: Json): str;
}
