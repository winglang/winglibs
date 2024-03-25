export default interface extern {
  _adminConfirmUser: (poolId: string, email: string) => Promise<void>,
  _initiateAuth: (clientId: string, email: string, password: string) => Promise<string>,
  _signUp: (clientId: string, email: string, password: string) => Promise<void>,
}
