export default interface extern {
  createClient: (options: ClientConfig) => Promise<Client$Inflight>,
  createDocumentClient: (options?: (CreateDocumentClientOptions) | undefined) => Promise<DocumentClient$Inflight>,
  getPort: () => Promise<number>,
  processRecordsAsync: (endpoint: string, tableName: string, handler: (arg0: StreamRecord) => Promise<void>, options?: (StreamConsumerOptions) | undefined) => Promise<void>,
  unmarshall: (item: Readonly<any>, options?: (Readonly<any>) | undefined) => Promise<Readonly<any>>,
}
export interface Credentials {
  readonly accessKeyId: string;
  readonly secretAccessKey: string;
}
export interface ClientConfig {
  readonly credentials: Credentials;
  readonly endpoint: string;
  readonly region: string;
}
export interface Client$Inflight {
  readonly createTable: (input: Readonly<any>) => Promise<Readonly<any>>;
  readonly deleteTable: (input: Readonly<any>) => Promise<Readonly<any>>;
  readonly describeTable: (input: Readonly<any>) => Promise<Readonly<any>>;
  readonly updateTimeToLive: (input: Readonly<any>) => Promise<Readonly<any>>;
}
export interface Credentials {
  readonly accessKeyId: string;
  readonly secretAccessKey: string;
}
export interface CreateDocumentClientOptions {
  readonly credentials?: (Credentials1) | undefined;
  readonly endpoint?: (string) | undefined;
  readonly region?: (string) | undefined;
}
export interface DocumentClient$Inflight {
  readonly batchGet: (input: Readonly<any>) => Promise<Readonly<any>>;
  readonly batchWrite: (input: Readonly<any>) => Promise<Readonly<any>>;
  readonly delete: (input: Readonly<any>) => Promise<Readonly<any>>;
  readonly get: (input: Readonly<any>) => Promise<Readonly<any>>;
  readonly put: (input: Readonly<any>) => Promise<Readonly<any>>;
  readonly query: (input: Readonly<any>) => Promise<Readonly<any>>;
  readonly scan: (input: Readonly<any>) => Promise<Readonly<any>>;
  readonly transactGet: (input: Readonly<any>) => Promise<Readonly<any>>;
  readonly transactWrite: (input: Readonly<any>) => Promise<Readonly<any>>;
  readonly update: (input: Readonly<any>) => Promise<Readonly<any>>;
}
export interface StreamRecordDynamodb {
  readonly ApproximateCreationDateTime: string;
  readonly Keys: Readonly<any>;
  readonly NewImage?: (Readonly<any>) | undefined;
  readonly OldImage?: (Readonly<any>) | undefined;
  readonly SequenceNumber: string;
  readonly SizeBytes: number;
  readonly StreamViewType: string;
}
export interface StreamRecord {
  readonly dynamodb: StreamRecordDynamodb;
  readonly eventID: string;
  readonly eventName: string;
}
export interface StreamConsumerOptions {
  readonly batchSize?: (number) | undefined;
  readonly startingPosition?: (string) | undefined;
}