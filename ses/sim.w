bring cloud;
bring util;
bring "./types.w" as types;

pub class EmailService_sim impl types.IEmailService {
  store: cloud.Bucket;
  new(props: types.EmailServiceProps) {
    this.store = new cloud.Bucket() as "Inbox";
  }

  pub inflight sendEmail(options: types.SendEmailOptions): str? {
    let id = util.nanoid().substring(0, 8);
    log("sending email {id}: {Json.stringify(options)}");
    this.store.put("{id}-{options.Source}-{options.Message?.Subject?.Data ?? ""}", Json.stringify(options));
    return id;
  }

  pub inflight sendRawEmail(options: types.SendRawEmailOptions): str? {
    let id = util.nanoid().substring(0, 8);
    log("sending raw email {id}: {Json.stringify(options)}");
    this.store.put("{id}-{options.RawMessage.Data}", Json.stringify(options));
    return id;
  }
}
