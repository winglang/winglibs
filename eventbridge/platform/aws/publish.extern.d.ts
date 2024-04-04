export default interface extern {
  _putEvent: (name: string, event: PutEventCommandInput) => Promise<void>,
}
export interface PutEventCommandEntry {
  readonly Detail: string;
  readonly DetailType: string;
  readonly EventBusName: string;
  readonly Resources: (readonly (string)[]);
  readonly Source: string;
}
export interface PutEventCommandInput {
  readonly Entries: (readonly (PutEventCommandEntry)[]);
}