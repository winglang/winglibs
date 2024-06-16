export default interface extern {
  _spawn: (command: string, args: (readonly (string)[]), options: Readonly<Record<string, Readonly<any>>>) => Promise<void>,
  env: () => Promise<Readonly<Record<string, string>>>,
  os: () => string,
}
