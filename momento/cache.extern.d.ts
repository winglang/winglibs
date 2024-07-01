export default interface extern {
  _get: (cacheName: string, key: string) => Promise<string | void>,
  _set: (cacheName: string, key: string, value: string, ttl: number) => Promise<void>,
}
