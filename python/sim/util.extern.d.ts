export default interface extern {
  contentHash: (files: (readonly (string)[]), cwd: string) => string,
  dirname: () => string,
  env: () => Promise<Readonly<Record<string, string>>>,
  os: () => string,
  shell: (command: string, args: (readonly (string)[]), pathEnv: string, cwd?: (string) | undefined) => Promise<string>,
}
