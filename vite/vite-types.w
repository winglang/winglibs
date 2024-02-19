pub struct ViteProps {
  /**
   * The root directory of the Vite project.
   */
  root: str;

  /**
   * The variables that will be passed to the browser.
   */
  publicEnv: Map<str>?;

  /**
   * Whether to generate type definitions or not.
   */
  generateTypeDefinitions: bool?;

  /**
   * The name of the browser variable that will be used to
   * access environment variables passed from the wing program.
   *
   * @default `wing`
   */
  publicEnvName: str?;

  /**
   * The name of the file that will be used to generate type definitions.
   */
   typeDefinitionsFilename: str?;
}
