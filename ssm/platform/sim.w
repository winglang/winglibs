bring cloud;
bring "../types.w" as types;

pub class Parameter impl types.IParameter {
  state: cloud.Bucket;
  key: str;

  new(props: types.ParameterProps) {
    this.state = new cloud.Bucket();
    this.key = "/config/{props.name}";
    this.state.addObject(this.key, props.value);
  }

  pub inflight value(): str {
    return this.state.get(this.key);
  }
}
