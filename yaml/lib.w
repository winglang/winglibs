pub struct ParseOptions {
  strict: bool?;
}

pub struct StringifyOptions {
  indent: num?;
}

pub class Util {
  pub static inflight parse(value: str, options: ParseOptions?): Json {
    return Extern._parse(value, options);
  }

  pub static inflight stringify(value: Json, options: StringifyOptions?): Json {
    return Extern._stringify(value, options);
  }

  pub static parseValue(value: str, options: ParseOptions?): Json {
    return Extern._preflight_parse(value, options);
  }

  pub static stringifyValue(value: Json, options: StringifyOptions?): Json {
    return Extern._preflight_stringify(value, options);
  }
}

class Extern {
  pub extern "./yaml.mts" static inflight _parse(value: str, options: ParseOptions?): Json;
  pub extern "./yaml.mts" static inflight _stringify(value: Json, options: StringifyOptions?): str;
  pub extern "./yaml.mts" static _preflight_parse(value: str, options: ParseOptions?): Json;
  pub extern "./yaml.mts" static _preflight_stringify(value: Json, options: StringifyOptions?): str;
}

