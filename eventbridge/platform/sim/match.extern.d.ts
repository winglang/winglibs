export default interface extern {
  matchesPattern: (obj: Readonly<any>, pattern: Readonly<any>) => Promise<boolean>,
}
