export default interface extern {
  _publish: (topicArn: string, message: string) => Promise<void>,
}
