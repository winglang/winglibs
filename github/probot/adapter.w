bring "../octokit/types.w" as octokit;
bring "./types.w" as probot;

pub inflight interface IProbotAppCredentialsSupplier {
  inflight getId(): str;
  inflight getWebhookSecret(): str;
  inflight getPrivateKey(): str;
}


pub struct ProbotAdapterProps {
  credentialsSupplier: IProbotAppCredentialsSupplier;
}

pub struct CreateAdapterOptions {
  appId: str;
  privateKey: str;
  webhookSecret: str;
}

pub class ProbotAdapter {
  extern "./probot.js" pub static inflight createProbotAdapter(options: CreateAdapterOptions): probot.ProbotInstance;

  credentialsSupplier: IProbotAppCredentialsSupplier;
  inflight var instance: probot.ProbotInstance;

  new(props: ProbotAdapterProps) {
    this.credentialsSupplier =  props.credentialsSupplier;
  }

  inflight new() {
    this.instance = ProbotAdapter.createProbotAdapter(
      appId: this.credentialsSupplier.getId(),
      privateKey: this.credentialsSupplier.getPrivateKey(),
      webhookSecret: this.credentialsSupplier.getWebhookSecret()
    );
  }

  pub inflight handlePullRequstOpened(handler: inflight (probot.PullRequestOpenedContext): void) {
    this.instance.webhooks?.on("pull_request.opened", handler);
  }

  pub inflight handlePullRequstReopened(handler: inflight (probot.PullRequestOpenedContext): void) {
    this.instance.webhooks?.on("pull_request.reopened", handler);
  }

  pub inflight handlePullRequstSync(handler: inflight (probot.PullRequestSyncContext): void) {
    this.instance.webhooks?.on("pull_request.synchronize", handler);
  }

  pub inflight handlePullRequstClosed(handler: inflight (probot.PullRequestClosedContext): void) {
    this.instance.webhooks?.on("pull_request.closed", handler);
  }

  pub inflight handlePush(handler: inflight (probot.PushContext): void) {
    this.instance.webhooks?.on("push", handler);
  }

  pub inflight verifyAndReceive(props: probot.VerifyAndReceieveProps) {
    this.instance.webhooks?.verifyAndReceive(props);
  }

  pub inflight auth(installationId: num): octokit.OctoKit {
    if let kit = this.instance.auth?.call(this.instance, installationId) {
      return kit;
    } else {
      throw "auth: fail to get octokit";
    }
  }
}
