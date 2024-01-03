bring cloud;
bring http;
bring ex;
bring util;
bring "./probot/types.w" as probot;
bring "./octokit/types.w" as octokit;
bring "./probot/adapter.w" as adapter;
bring "./utils/lowkeys.w" as lowkeys;
bring "./ngrok/ngrok.w" as ngrok;

pub interface IProbotAppCredentialsSupplier extends adapter.IProbotAppCredentialsSupplier {

}

pub struct ProbotAppProps {
  credentialsSupplier: IProbotAppCredentialsSupplier;
  // currently we have to provide these handlers on construction - see https://github.com/winglang/wing/issues/4324
  onPullRequestOpened: inflight (probot.PullRequestOpenedContext): void;
  onPullRequestReopened: inflight (probot.PullRequestOpenedContext): void;
}


pub class ProbotApp {
  credentialsSupplier: IProbotAppCredentialsSupplier;
  adapter: adapter.ProbotAdapter;
  api: cloud.Api;

  var onPullRequestOpenedHandler: inflight (probot.PullRequestOpenedContext): void;
  var onPullRequestReopenedHandler: inflight (probot.PullRequestOpenedContext): void;

  extern "./probot/probot.js" pub static inflight createGithubAppJwt(appId: str, privateKey: str): str;

  new(props: ProbotAppProps) {
    this.credentialsSupplier =  props.credentialsSupplier;
    this.adapter = new adapter.ProbotAdapter(credentialsSupplier: props.credentialsSupplier);

    this.onPullRequestOpenedHandler = props.onPullRequestOpened;
    this.onPullRequestReopenedHandler = props.onPullRequestReopened;

    this.api = new cloud.Api();
    this.api.post("/webhook", inflight (req) => {
      this.listen(this.getVerifyAndReceievePropsProps(req));
      return {
        status: 200
      };
    });
    if !std.Node.of(this).app.isTestEnvironment {
      let target = util.env("WING_TARGET");
      if target == "sim" {
        let devNgrok = new ngrok.Ngrok(
          url: this.api.url,
        );
          
        new cloud.OnDeploy(inflight () => {
          this.updateWebhookUrl("{devNgrok.url}/webhook");
        });
      } else {
        new cloud.OnDeploy(inflight () => {
          this.updateWebhookUrl("{this.api.url}/webhook");
        });
      }
    }
  }

  pub onPullRequestOpened(handler: inflight (probot.PullRequestOpenedContext): void) {
    this.onPullRequestOpenedHandler = handler;
  }

  pub onPullRequestReopened(handler: inflight (probot.PullRequestOpenedContext): void) {
    this.onPullRequestReopenedHandler = handler;
  }

  pub inflight updateWebhookUrl(url: str) {
    let jwt = ProbotApp.createGithubAppJwt(this.credentialsSupplier.getId(), this.credentialsSupplier.getPrivateKey());


    let res = http.patch(
      "https://api.github.com/app/hook/config",
      headers: {
        "Accept" => "application/vnd.github+json",
        "Authorization" => "Bearer {jwt}",
        "X-GitHub-Api-Version" => "2022-11-28"
      },
      body: Json.stringify({
        url: url
      }),
    );

    if (res.status == 200) {
      log("GitHub app: webhook url updated: {url}");
    }
    else {
      log("GitHub app: failed to update the webhook url: {res.body}");
      log("You have to manually update your webhook URL to {url}");
    }
  }

  inflight getVerifyAndReceievePropsProps(req: cloud.ApiRequest): probot.VerifyAndReceieveProps {
    let lowkeysHeaders = lowkeys.LowkeysMap.fromMap(req.headers ?? {});
    if !lowkeysHeaders.has("x-github-delivery") {
      throw "getVerifyProps: missing id header";
    }

    let id = lowkeysHeaders.get("x-github-delivery");

    if !lowkeysHeaders.has("x-github-event") {
      throw "getVerifyProps: missing name header";
    }

    let name = lowkeysHeaders.get("x-github-event");

    let signature = lowkeysHeaders.get("x-hub-signature-256");

    if let payload = req.body {
      return {
        id: id,
        name: name,
        signature: signature,
        payload: payload,
      };
    }

    throw "getVerifyProps: missing body";
  }

  inflight listen(props: probot.VerifyAndReceieveProps) {
    this.adapter.handlePullRequstOpened(inflight (context: probot.PullRequestOpenedContext): void => {
      this.onPullRequestOpenedHandler(context);
    });

    this.adapter.handlePullRequstReopened(inflight (context: probot.PullRequestOpenedContext): void => {
      this.onPullRequestReopenedHandler(context);
    });

    this.adapter.handlePullRequstClosed(inflight (context: probot.PullRequestClosedContext): void => {
      // TODO implement 
    });

    this.adapter.handlePullRequstSync(inflight (context: probot.PullRequestSyncContext): void => {
      // TODO implement 
    });

    this.adapter.handlePush(inflight (context: probot.PushContext) => {
      // TODO implement 
    });

    this.adapter.verifyAndReceive(props);
  }
}
