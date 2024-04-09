export default interface extern {
  _invoke: (functionArn: string, payload?: (string) | undefined) => Promise<(string) | undefined>,
}
