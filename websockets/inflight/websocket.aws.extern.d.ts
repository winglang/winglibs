export default interface extern {
  _postToConnection: (endpointUrl: string, connectionId: string, message: string) => Promise<void>,
}
