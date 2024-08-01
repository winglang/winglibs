bring util;


pub class TableBase {
  protected getImplicidTableName(path: str, addr: str): str {
    let tableAddr = "{addr.substring(42-8)}";
    let var tablePath = "{regex.compile("[^a-zA-Z0-9._-]+").replaceAll(path, "-")}";
    if util.env("WING_TARGET") != "sim" {
      tablePath = tablePath.substring(21, (255+21)-9);
    }
    return tablePath + "-" + tableAddr;
  }
}