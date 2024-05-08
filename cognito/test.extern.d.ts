export default interface extern {
  fetch: (url: string, credentials: Readonly<any>) => Promise<number>,
}
