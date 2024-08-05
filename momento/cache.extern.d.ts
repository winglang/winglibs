export default interface extern {
  _get: (token: string, cacheName: string, key: string) => Promise<string | void>,
  _set: (token: string, cacheName: string, key: string, value: string, ttl: number) => Promise<void>,
}
