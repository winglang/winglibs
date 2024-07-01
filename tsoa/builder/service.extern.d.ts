export default interface extern {
  generateRoutes: (generatorScript: string, outputDirectory: string, controllerPathGlobs: (string)[]) => Promise<void>,
}
