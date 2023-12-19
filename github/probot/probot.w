bring cloud;
bring http;
bring ex;
bring util;
bring fs;
bring "./types.w" as probot;
bring "../octokit/types.w" as octokit;
bring "./adapter.w" as adapter;
bring "../utils/lowkeys.w" as lowkeys;
bring "../ngrok/ngrok.w" as ngrok;

pub struct ProbotAppProps {
  appId: str;
  privateKey: str;
  webhookSecret: str;

  onPullRequestOpened: inflight (probot.IPullRequestOpenedContext): void;
  onPullRequestReopened: inflight (probot.IPullRequestOpenedContext): void;
}

pub class ProbotApp {
  pub appId: str;
  pub privateKey: str;
  pub webhookSecret: str;
  adapter: adapter.ProbotAdapter;
  api: cloud.Api;

  var onPullRequestOpenedHandler: inflight (probot.IPullRequestOpenedContext): void;
  var onPullRequestReopenedHandler: inflight (probot.IPullRequestOpenedContext): void;

  extern "./probot.mts" pub static inflight createGithubAppJwt(appId: str, privateKey: str): str;

  new(props: ProbotAppProps) {
    this.appId =  props.appId;
    this.privateKey = props.privateKey;
    this.webhookSecret = props.webhookSecret;
    this.adapter = new adapter.ProbotAdapter(appId: props.appId, privateKey: props.privateKey, webhookSecret: props.webhookSecret);

    this.onPullRequestOpenedHandler = props.onPullRequestOpened;
    this.onPullRequestReopenedHandler = props.onPullRequestReopened;

    this.api = new cloud.Api();
    this.api.post("/webhook", inflight (req) => {
      fs.writeFile("/tmp/112", "sdsds {this.onPullRequestReopenedHandler}");
      this.listen(this.getVerifyAndReceievePropsProps(req));

      return {
        status: 200
      };
    });

    let devNgrok = new ngrok.Ngrok(
      url: this.api.url,
    );

    new cloud.OnDeploy(inflight () => {
      this.updateWebhookUrl("{devNgrok.url}/webhook");
    });

    
  }

  pub onPullRequestOpened(handler: inflight (probot.IPullRequestOpenedContext): void) {
    this.onPullRequestOpenedHandler = handler;
  }

  pub onPullRequestReopened(handler: inflight (probot.IPullRequestOpenedContext): void) {
    this.onPullRequestReopenedHandler = handler;
    log("aaaa {this.onPullRequestReopenedHandler}");
  }

  pub inflight updateWebhookUrl(url: str) {
    let jwt = ProbotApp.createGithubAppJwt(this.appId, this.privateKey);

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
    let xxxx = this.onPullRequestReopenedHandler;
    this.adapter.handlePullRequstOpened(inflight (context: probot.IPullRequestOpenedContext): void => {
      
      log("22222 {xxxx}");
      this.onPullRequestOpenedHandler(context);
    });

    this.adapter.handlePullRequstReopened(inflight (context: probot.IPullRequestOpenedContext): void => {
      fs.writeFile("/tmp/111", "sadsad1 {xxxx}");
      log("11111 {xxxx}");
      this.onPullRequestReopenedHandler(context);
    });

    this.adapter.handlePullRequstClosed(inflight (context: probot.IPullRequestClosedContext): void => {
      
    });

    this.adapter.handlePullRequstSync(inflight (context: probot.IPullRequestSyncContext): void => {
      
    });

    this.adapter.handlePush(inflight (context: probot.IPushContext) => {
      
    });

    this.adapter.verifyAndReceive(props);
  }
}
