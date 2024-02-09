bring "../octokit/types.w" as octokit;

struct ProbotRepositoryOwner {
  name: str;
  login: str;
}

struct ProbotRepository {
  id: str;
  name: str;
  owner: ProbotRepositoryOwner;
  full_name: str;
}

struct PullRequestRef {
  sha: str;
  ref: str;
}
struct PullRequestUser {
  login: str;
}
struct PullRequestPR {
  head: PullRequestRef;
  base: PullRequestRef;
  user: PullRequestUser;
  number: num;
  title: str;
}

struct PullRequestInstallation {
  id: num;
}

struct PullRequestPayload {
  number: num;
  repository: ProbotRepository;
  pull_request: PullRequestPR;
  installation: PullRequestInstallation?;
}

pub struct Context {
  id: str;
  octokit: octokit.OctoKit;
}

pub struct PullRequestContext extends Context {
  payload: PullRequestPayload;
}

pub struct PullRequestSyncContext extends PullRequestContext {}

pub struct PullRequestOpenedContext extends PullRequestContext {}

pub struct PullRequestClosedContext extends PullRequestContext {}

struct PushPayload {
  repository: ProbotRepository;
  installation: PullRequestInstallation?;
  after: str;
  ref: str;
}

pub struct PushContext extends Context {
  payload: PushPayload;
}

pub struct VerifyAndReceieveProps {
  id: str;
  name: str;
  signature: str;
  payload: str;
}

pub interface IProbotWebhooks {
  inflight on(name: str, handler: inflight (): void): void;
  inflight verifyAndReceive(props: VerifyAndReceieveProps): void;
}

pub interface IProbotAuth {
  inflight call(ProbotInstance, installationId: num): octokit.OctoKit;
}

pub struct ProbotInstance {
  webhooks: IProbotWebhooks;
  auth: IProbotAuth;
}
