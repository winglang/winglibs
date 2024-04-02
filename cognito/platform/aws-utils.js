import {
  AdminConfirmSignUpCommand,
  CognitoIdentityProviderClient,
  InitiateAuthCommand,
  SignUpCommand,
} from "@aws-sdk/client-cognito-identity-provider";

/**
 * @param {string} clientId
 * @param {string} username
 * @param {string} password
 */
export const _signUp = async (clientId, username, password) => {
  const client = new CognitoIdentityProviderClient();

  const command = new SignUpCommand({
    ClientId: clientId,
    Username: username,
    Password: password,
    UserAttributes: [
      {
        Name: "email",
        Value: username,
      },
      {
        Name: "name",
        Value: username,
      },
    ],
  });

  await client.send(command);
};

/**
 * @param {string} poolId
 * @param {string} username
 */
export const _adminConfirmUser = async (poolId, username) => {
  const client = new CognitoIdentityProviderClient();

  const command = new AdminConfirmSignUpCommand({
    UserPoolId: poolId,
    Username: username,
  });

  await client.send(command);
};

/**
 * @param {string} clientId
 * @param {string} username
 * @param {string} password
 */
export const _initiateAuth = async (
  clientId,
  username,
  password
) => {
  const client = new CognitoIdentityProviderClient();

  const command = new InitiateAuthCommand({
    ClientId: clientId,
    AuthFlow: "USER_PASSWORD_AUTH",
    AuthParameters: {
      PASSWORD: password,
      USERNAME: username,
    },
  });

  const res = await client.send(command);
  return res.AuthenticationResult?.IdToken;
};
