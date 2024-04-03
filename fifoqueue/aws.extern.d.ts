export default interface extern {
  _push: (queueUrl: string, message: string, groupId: string) => Promise<void>,
}
