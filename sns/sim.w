bring cloud;
bring util;
bring "./types.w" as types;

pub class MobileClient impl types.IMobileClient {
  store: cloud.Bucket;
  new() {
    this.store = new cloud.Bucket() as "Inbox";
  }

  pub inflight publish(options: types.PublishOptions): types.PublishResult {
    let id = util.nanoid().substring(0, 8);
    this.store.put("{id}-{options.Subject ?? ""}", Json.stringify(options));
    return {
      MessageId: id,
    };
  }
}
