bring "../octokit/types.w" as octokit;
bring "./types.w" as probot;

pub struct ProbotAdapterProps {
  appId: str;
  privateKey: str;
  webhookSecret: str;
}

pub struct CreateAdapterOptions {
  appId: str;
  privateKey: str;
  webhookSecret: str;
}

pub class ProbotAdapter {
  extern "./probot.mts" pub static inflight createProbotAdapter(options: CreateAdapterOptions): probot.ProbotInstance;

  pub appId: str;
  pub privateKey: str;
  pub webhookSecret: str;
  inflight var instance: probot.ProbotInstance?;

  new(props: ProbotAdapterProps) {
    this.appId =  props.appId;
    this.privateKey = props.privateKey;
    this.webhookSecret = props.webhookSecret;
  }

  inflight new() {
    this.instance = ProbotAdapter.createProbotAdapter(appId: this.appId, privateKey: this.privateKey, webhookSecret: this.webhookSecret);
  }

  pub inflight handlePullRequstOpened(handler: inflight (probot.IPullRequestOpenedContext): void) {
    this.instance?.webhooks?.on("pull_request.opened", handler);
  }

  pub inflight handlePullRequstReopened(handler: inflight (probot.IPullRequestOpenedContext): void) {
    this.instance?.webhooks?.on("pull_request.reopened", handler);
  }

  pub inflight handlePullRequstSync(handler: inflight (probot.IPullRequestSyncContext): void) {
    this.instance?.webhooks?.on("pull_request.synchronize", handler);
  }

  pub inflight handlePullRequstClosed(handler: inflight (probot.IPullRequestClosedContext): void) {
    this.instance?.webhooks?.on("pull_request.closed", handler);
  }

  pub inflight handlePush(handler: inflight (probot.IPushContext): void) {
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
