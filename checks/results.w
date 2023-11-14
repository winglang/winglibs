bring cloud;

pub struct CheckResult {
  /** a unique id of the check */
  checkid: str;

  /** the construct path of the check */
  checkpath: str;

  /** timestamp the check was run */
  timestamp: str;

  /** true if the test was successful */
  ok: bool;

  /** error message if the test failed */
  error: str?;
}

/** Centralized storage for check results */
pub class Results {
  pub static of(scope: std.IResource): Results {
    let root = std.Node.of(scope).root;
    let id = "cloud.CheckResults";
    let exists: Results? = unsafeCast(root.node.tryFindChild(id));
    let rootAsResource: Results = unsafeCast(root);
    return exists ?? new Results() as id in rootAsResource;
  }

  bucket: cloud.Bucket;

  new() {
    this.bucket = new cloud.Bucket() as "results";
  }

  pub inflight store(result: CheckResult) {
    let checkid = result.checkid;
    let body = Json.stringify(result);
    let key = this.makeLatestKey(checkid);
    log("storing ${key}");
    this.bucket.putJson(key, result);
    this.bucket.putJson(this.makeKey(checkid, "${result.timestamp}.json"), result);
  }

  pub inflight latest(checkid: str): CheckResult? {
    let key = this.makeLatestKey(checkid);
    let s = this.bucket.tryGetJson(key);
    return CheckResult.fromJson(s);
  }

  inflight makeKey(checkid: str, key: str): str {
    return "${checkid}/${key}";
  }

  inflight makeLatestKey(checkid: str): str {
    return this.makeKey(checkid, "latest.json");
  }
}