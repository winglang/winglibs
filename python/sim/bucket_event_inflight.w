bring cloud;
bring "./inflight.w" as inflyght;
bring "../types.w" as types;

pub class BucketEventInflight extends inflyght.Inflight impl cloud.IBucketEventHandler {
  new(props: types.InflightProps) {
    super(props);
  }

  pub inflight handle(message: str, type: cloud.BucketEventType): void {
    this._handle(Json.stringify({ key: message, type: "{type}" }));
  }
}
