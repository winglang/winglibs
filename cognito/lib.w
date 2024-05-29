bring cloud;
bring util;
bring "./types.w" as types;
bring "./platform/sim.w" as sim;
bring "./platform/tfaws.w" as tfaws;

pub class Cognito impl types.ICognito {
  inner: types.ICognito;
  pub clientId: str;
  pub userPoolId: str;
  pub identityPoolId: str;
  new(api: cloud.Api, props: types.CognitoProps?) {
    let target = util.env("WING_TARGET");
    if target == "sim" {
      this.inner = new sim.Cognito_sim(api, props) as "sim";
      this.clientId = "sim-client-id";
      this.userPoolId = "sim-user-pool-id";
      this.identityPoolId = "sim-identity-pool-id";
    } elif target == "tf-aws" {
      let auth = new tfaws.Cognito_tfaws(api, props) as "tf-aws";
      this.clientId = auth.clientId;
      this.userPoolId = auth.userPoolId;
      this.identityPoolId = auth.identityPoolId;
      this.inner = auth;
    } else {
      throw "Unsupported target {target}";
    }

    nodeof(this).icon = "lock-closed";
    nodeof(this).color = "emerald";
  }

  pub get(path: str) {
    this.inner.get(path);
  }

  pub post(path: str) {
    this.inner.post(path);
  }

  pub put(path: str) {
    this.inner.put(path);
  }

  pub patch(path: str) {
    this.inner.patch(path);
  }

  pub delete(path: str) {
    this.inner.delete(path);
  }

  pub head(path: str) {
    this.inner.head(path);
  }

  pub options(path: str) {
    this.inner.options(path);
  }

  pub connect(path: str) {
    this.inner.connect(path);
  }

  pub inflight signUp(email: str, password: str): void {
    this.inner.signUp(email, password);
  }

  pub inflight adminConfirmUser(email: str): void {
    this.inner.adminConfirmUser(email);
  }

  pub inflight initiateAuth(email: str, password: str): str {
    return this.inner.initiateAuth(email, password);
  }

  pub inflight getId(poolId: str, identityPoolId: str, token: str): str {
    return this.inner.getId(poolId, identityPoolId, token);
  }

  pub inflight getCredentialsForIdentity(token: str, identityId: str): Json {
    return this.inner.getCredentialsForIdentity(token, identityId);
  }
}
