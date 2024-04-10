export default interface extern {
  env: () => Promise<Readonly<Record<string, string>>>,
  os: () => string,
}
