import { AdminConfirmSignUpCommand, CognitoIdentityProviderClient, ConfirmSignUpCommand, InitiateAuthCommand, SignUpCommand } from "@aws-sdk/client-cognito-identity-provider";

export const _signUp = async (clientId: string, username: string, password: string) => {
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
      }
    ]
  });

  await client.send(command);
  
};

export const _adminConfirmUser = async (poolId: string, username: string) => {
  const client = new CognitoIdentityProviderClient();

  const command = new AdminConfirmSignUpCommand({
    UserPoolId: poolId,
    Username: username,
  });

  await client.send(command);
};

export const _initiateAuth = async (clientId: string, username: string, password: string) => {
  const client = new CognitoIdentityProviderClient();

  const command = new InitiateAuthCommand({
    ClientId: clientId,
    AuthFlow: "USER_PASSWORD_AUTH",
    AuthParameters: {
      "PASSWORD": password,
      "USERNAME": username,
    },
  });

  const res = await client.send(command);
  return res.AuthenticationResult?.IdToken;
};
