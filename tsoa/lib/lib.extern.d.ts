export default interface extern {
  startService: (entrypointDir: string, workDir: string, props: ServiceProps) => Promise<StartResponse$Inflight>,
}
export interface SpecProps {
  readonly outputDirectory?: (string) | undefined;
  readonly specVersion?: (number) | undefined;
}
export interface ServiceProps {
  readonly controllerPathGlobs: (readonly (string)[]);
  readonly entryFile?: (string) | undefined;
  readonly outputDirectory: string;
  readonly routesDir: string;
  readonly spec?: (SpecProps) | undefined;
}
export interface StartResponse$Inflight {
  readonly close: () => Promise<void>;
  readonly port: () => Promise<number>;
}