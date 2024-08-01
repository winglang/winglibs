export default interface extern {
  _dec: (amount: number, key: string, tableName: string, hashKey: string, initial: number) => Promise<number>,
  _inc: (amount: number, key: string, tableName: string, hashKey: string, initial: number) => Promise<number>,
  _peek: (key: string, tableName: string, hashKey: string, initial: number) => Promise<number>,
  _set: (value: number, key: string, tableName: string, hashKey: string) => Promise<void>,
}
