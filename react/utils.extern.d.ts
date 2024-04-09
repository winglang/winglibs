export default interface extern {
  exec: (command: string, env: Record<string, string>, cwd: string) => Promise<() => Promise<void>>,
  execSync: (command: string, env: Record<string, string>, cwd: string) => void,
  getPort: () => Promise<number>,
  serveStaticFiles: (path: string, port: number) => Promise<() => Promise<void>>,
}
