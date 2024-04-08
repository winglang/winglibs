export default interface extern {
  findPort: () => Promise<number>,
  spawn: (file: string, args: (readonly (string)[]), props?: (ServiceProps) | undefined) => Promise<Process$Inflight>,
}
export interface ServiceProps {
  readonly cwd?: (string) | undefined;
  readonly env?: (Readonly<Record<string, string>>) | undefined;
}
export interface Process$Inflight {
  readonly kill: () => Promise<void>;
}