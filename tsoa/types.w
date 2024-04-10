pub struct SpecProps {
  outputDirectory: str?;
  specVersion: num?;
}

pub struct StartServiceOptions {
  currentdir: str;
  basedir: str;
  workdir: str;
  options: ServiceProps;
  homeEnv: str;
  pathEnv: str;
  clients: Map<std.Resource>;
}

/**
 * Properties for a new TSOA service.
 */
pub struct ServiceProps {
  /**
   * The entry point to your API
   */
  entryFile: str?;
  /**
   * An array of path globs that point to your route controllers that you would like to have tsoa include.
   */
  controllerPathGlobs: Array<str>;
  /**
   * Generated SwaggerConfig.json will output here
   */
  outputDirectory: str;
  /**
   * Extend generated swagger spec with this object
   */
  spec: SpecProps?;
  /**
   * Routes directory; generated routes.ts (which contains the generated code wiring up routes using middleware of choice) will be dropped here
   */
  routesDir: str;
}

/**
 * Options for the lift method.
 */
pub struct LiftOptions {
  /**
   * List of operations to allow for this client
   */
  allow: Array<str>;
}

/**
 * Starts a new TSOA service.
 */
pub interface IService {
  lift(id: str, client: std.Resource, ops: LiftOptions): void;
}
