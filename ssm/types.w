bring cloud;

pub interface IParameter extends std.IResource {
  inflight value(): str;
}

pub struct ParameterProps {
  name: str;
  value: str;
}