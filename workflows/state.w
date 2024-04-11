bring cloud;

pub class State {
  bucket: cloud.Bucket;
  key: str;
  errorKey: str;

  new() {
    this.bucket = new cloud.Bucket();
    this.key = "state.json";
    this.errorKey = "error.json";
  }

  pub inflight clear() {
    this.bucket.delete(this.key);
    this.bucket.delete(this.errorKey);
  }

  pub inflight get(): Json {
    return this.bucket.tryGetJson(this.key) ?? {};
  }

  pub inflight set(data: Json) {
    this.bucket.putJson(this.key, data);
  }

  pub inflight setError(err: Json) {
    this.bucket.putJson(this.errorKey, err);
  }

  pub inflight getError(): Json? {
    return this.bucket.tryGetJson(this.errorKey);
  }
}
