export default interface extern {
  _parse: (value: string, options?: (ParseOptions) | undefined) => Promise<Readonly<any>>,
  _preflight_parse: (value: string, options?: (ParseOptions) | undefined) => Readonly<any>,
  _preflight_stringify: (value: Readonly<any>, options?: (StringifyOptions) | undefined) => string,
  _stringify: (value: Readonly<any>, options?: (StringifyOptions) | undefined) => Promise<string>,
}
export interface ParseOptions {
  readonly strict?: (boolean) | undefined;
}
export interface StringifyOptions {
  readonly indent?: (number) | undefined;
}