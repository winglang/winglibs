export default interface extern {
  mergeJson: (a: Readonly<any>, b: Readonly<any>) => Promise<Readonly<any>>,
}
