export default interface extern {
  _query: (query: string, creds: ConnectionOptions) => Promise<(readonly (Readonly<Record<string, Readonly<any>>>)[])>,
}
export interface ConnectionOptions {
  readonly database: string;
  readonly host: string;
  readonly password: string;
  readonly port?: (number) | undefined;
  readonly ssl: boolean;
  readonly user: string;
}