bring "../octokit/types.w" as octokit;
bring "./types.w" as probot;
bring cloud;

pub struct ProbotAdapterProps {
  appId: cloud.Secret;
  privateKey: cloud.Secret;
  webhookSecret: cloud.Secret;
}

pub struct CreateAdapterOptions {
  appId: str;
  privateKey: str;
  webhookSecret: str;
}

pub class ProbotAdapter {
  extern "./probot.js" pub static inflight createProbotAdapter(options: CreateAdapterOptions): probot.ProbotInstance;

  pub appId: cloud.Secret;
  pub privateKey: cloud.Secret;
  pub webhookSecret: cloud.Secret;
  inflight var instance: probot.ProbotInstance?;

  new(props: ProbotAdapterProps) {
    this.appId =  props.appId;
    this.privateKey = props.privateKey;
    this.webhookSecret = props.webhookSecret;
  }

  inflight new() {
    this.instance = ProbotAdapter.createProbotAdapter(
      appId: this.appId.value(), 
      privateKey: this.privateKey.value(), 
      webhookSecret: this.webhookSecret.value()
    );
  }

  pub inflight handlePullRequstOpened(handler: inflight (probot.PullRequestOpenedContext): void) {
    this.instance?.webhooks?.on("pull_request.opened", handler);
  }

  pub inflight handlePullRequstReopened(handler: inflight (probot.PullRequestOpenedContext): void) {
    this.instance?.webhooks?.on("pull_request.reopened", handler);
  }

  pub inflight handlePullRequstSync(handler: inflight (probot.PullRequestSyncContext): void) {
    this.instance?.webhooks?.on("pull_request.synchronize", handler);
  }

  pub inflight handlePullRequstClosed(handler: inflight (probot.PullRequestClosedContext): void) {
    this.instance?.webhooks?.on("pull_request.closed", handler);
  }

  pub inflight handlePush(handler: inflight (probot.PushContext): void) {
    this.instance?.webhooks?.on("push", handler);
  }

  pub inflight verifyAndReceive(props: probot.VerifyAndReceieveProps) {
    this.instance?.webhooks?.verifyAndReceive(props);
  }

  pub inflight auth(installationId: num): octokit.OctoKit {
    if let kit = this.instance?.auth?.call(this.instance, installationId) {
      return kit;
    } else {
      throw "auth: fail to get octokit";
    }
  }
}