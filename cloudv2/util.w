bring "constructs" as constructs;

internal class Util {
  // TODO: private constructors - https://github.com/winglang/wing/issues/4377
  // TODO: expose ResourceNames class from SDK
  internal static friendlyName(c: constructs.IConstruct): str {
    return nodeof(c).id + Util.shortHash(c);
  }

  internal static shortHash(c: constructs.IConstruct): str {
    let hash = nodeof(c).addr;
    return hash.substring(hash.length - 8);
  }
}
