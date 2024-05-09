export default interface extern {
  _adminConfirmUser: (poolId: string, email: string) => Promise<void>,
  _getCredentialsForIdentity: (poolId: string, token: string, identityPoolId: string) => Promise<Readonly<any>>,
  _getId: (poolId: string, identityPoolId: string, token: string) => Promise<string>,
  _initiateAuth: (clientId: string, email: string, password: string) => Promise<string>,
  _signUp: (clientId: string, email: string, password: string) => Promise<void>,
}
