bring cloud;
bring fs;
bring ui;
bring sim;
bring "./types.w" as types;

struct EmailInfo {
  to: Array<str>;
  subject: str;
  text: str;
  html: str?;
}

inflight class EmailBackend impl sim.IResource {
  var data: MutArray<EmailInfo>;
  stateFile: str;

  new(ctx: sim.IResourceContext) {
    this.stateFile = fs.join(ctx.statedir(), "emails.json");
    if fs.exists(this.stateFile) {
      // TODO: MutArray<EmailInfo>.fromJson(...) - https://github.com/winglang/wing/issues/1796
      this.data = unsafeCast(fs.readJson(this.stateFile));
    } else {
      this.data = MutArray<EmailInfo>[];
    }
  }

  pub inflight onStop() {
    fs.writeJson(this.stateFile, this.data.copy());
  }

  pub inflight send(options: types.SendEmailOptions): void {
    this.data.push({
      to: options.to,
      subject: options.subject,
      text: options.text,
      html: options.html,
    });
  }

  pub inflight list(): Array<EmailInfo> {
    return this.data.copy();
  }

  pub inflight reset(): void {
    this.data = MutArray<EmailInfo>[];
  }
}

internal class Email_sim impl types.IEmail {
  backend: sim.Resource;
  sender: str;

  new(props: types.EmailProps) {
    this.sender = props.sender;
    this.backend = new sim.Resource(inflight (ctx) => {
      return new EmailBackend(ctx);
    }) as "EmailBackend";
  }

  pub addUI(scope: std.IResource): void {
    new ui.Table(scan: inflight () => {
      return unsafeCast(this.list());
    }) as "EmailsTable" in scope;

    new ui.Button("Clear history", inflight () => {
      this.reset();
    }) as "ClearHistoryButton" in scope;
  }

  pub inflight send(options: types.SendEmailOptions): void {
    this.backend.call("send", [Json options]);
    log("Fake email sent from {this.sender}: {Json options}");
  }

  pub inflight list(): Array<EmailInfo> {
    // TODO: Array<EmailInfo>.fromJson(...) - https://github.com/winglang/wing/issues/1796
    return unsafeCast(this.backend.call("list", []));
  }

  pub inflight reset(): void {
    this.backend.call("reset", []);
  }
}
