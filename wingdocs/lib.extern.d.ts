export default interface extern {
  shell: (cmd: string, env: Readonly<Record<string, string>>) => void,
}
