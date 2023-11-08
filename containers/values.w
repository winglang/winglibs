bring util;
bring fs;
bring "./utils.w" as utils;

pub class Values {
  pub static all(): Map<str> {
    let all = MutMap<str>{};

    if let valuesFile = util.tryEnv("WING_VALUES_FILE") {
      if valuesFile != "undefined" { // bug
        if !fs.exists(valuesFile) {
          throw "Values file ${valuesFile} not found";
        }

        for x in fs.readYaml(valuesFile) {
          for entry in Json.entries(x) {
            all.set(entry.key, entry.value.asStr());
          }
        }
      }
    }

    if let values = util.tryEnv("WING_VALUES") {
      if values != "undefined" {
        for v in values.split(",") {
          let kv = v.split("=");
          let key = kv.at(0);
          let value = kv.at(1);
          all.set(key, value);
        }
      }
    }

    return all.copy();
  }

  pub static tryGet(key: str): str? {
    return Values.all().tryGet(key);
  }

  pub static has(key: str): bool {
    return Values.tryGet(key)?;
  }

  pub static get(key: str): str {
    if let value = Values.tryGet(key) {
      return value;
    } else {
      throw "Missing platform value '${key}' (use --values or -v)";
    }
  }
}