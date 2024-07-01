export default interface extern {
  prepareHandler: (shouldBuildRoutes: boolean, outputDirectory: string, controllerPathGlobs: (string)[]) => (arg0: Readonly<any>) => Promise<Readonly<any>>,
}
