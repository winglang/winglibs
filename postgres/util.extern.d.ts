export default interface extern {
  isPortOpen: (port: string) => Promise<boolean>,
}
