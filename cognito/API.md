## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/cognito.Cognito">Cognito</a>
  - <a href="#@winglibs/cognito.platform.Cognito_tfaws">platform.Cognito_tfaws</a>
  - <a href="#@winglibs/cognito.platform.Cognito_sim">platform.Cognito_sim</a>
- **Interfaces**
  - <a href="#@winglibs/cognito.ICognito">ICognito</a>
- **Structs**
  - <a href="#@winglibs/cognito.CognitoProps">CognitoProps</a>
- **Enums**
  - <a href="#@winglibs/cognito.AuthenticationType">AuthenticationType</a>

### Cognito (preflight class) <a class="wing-docs-anchor" id="@winglibs/cognito.Cognito"></a>

*No description*

#### Constructor

```
new(api: Api, props: CognitoProps?): Cognito
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>clientId</code> | <code>str</code> | *No description* |
| <code>identityPoolId</code> | <code>str</code> | *No description* |
| <code>userPoolId</code> | <code>str</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight adminConfirmUser(email: str): void</code> | *No description* |
| <code>connect(path: str): void</code> | *No description* |
| <code>delete(path: str): void</code> | *No description* |
| <code>get(path: str): void</code> | *No description* |
| <code>inflight getCredentialsForIdentity(token: str, identityId: str): Json</code> | *No description* |
| <code>inflight getId(poolId: str, identityPoolId: str, token: str): str</code> | *No description* |
| <code>head(path: str): void</code> | *No description* |
| <code>inflight initiateAuth(email: str, password: str): str</code> | *No description* |
| <code>options(path: str): void</code> | *No description* |
| <code>patch(path: str): void</code> | *No description* |
| <code>post(path: str): void</code> | *No description* |
| <code>put(path: str): void</code> | *No description* |
| <code>inflight signUp(email: str, password: str): void</code> | *No description* |

### platform.Cognito_tfaws (preflight class) <a class="wing-docs-anchor" id="@winglibs/cognito.platform.Cognito_tfaws"></a>

*No description*

#### Constructor

```
new(api: Api, props: CognitoProps?): Cognito_tfaws
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>clientId</code> | <code>str</code> | *No description* |
| <code>identityPoolId</code> | <code>str</code> | *No description* |
| <code>userPoolId</code> | <code>str</code> | *No description* |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>static inflight _adminConfirmUser(poolId: str, email: str): void</code> | *No description* |
| <code>static inflight _getCredentialsForIdentity(poolId: str, token: str, identityPoolId: str): Json</code> | *No description* |
| <code>static inflight _getId(poolId: str, identityPoolId: str, token: str): str</code> | *No description* |
| <code>static inflight _initiateAuth(clientId: str, email: str, password: str): str</code> | *No description* |
| <code>static inflight _signUp(clientId: str, email: str, password: str): void</code> | *No description* |
| <code>inflight adminConfirmUser(email: str): void</code> | *No description* |
| <code>connect(path: str): void</code> | *No description* |
| <code>delete(path: str): void</code> | *No description* |
| <code>get(path: str): void</code> | *No description* |
| <code>inflight getCredentialsForIdentity(token: str, identityId: str): Json</code> | *No description* |
| <code>inflight getId(poolId: str, identityPoolId: str, token: str): str</code> | *No description* |
| <code>head(path: str): void</code> | *No description* |
| <code>inflight initiateAuth(email: str, password: str): str</code> | *No description* |
| <code>options(path: str): void</code> | *No description* |
| <code>patch(path: str): void</code> | *No description* |
| <code>post(path: str): void</code> | *No description* |
| <code>put(path: str): void</code> | *No description* |
| <code>inflight signUp(email: str, password: str): void</code> | *No description* |

### platform.Cognito_sim (preflight class) <a class="wing-docs-anchor" id="@winglibs/cognito.platform.Cognito_sim"></a>

*No description*

#### Constructor

```
new(api: Api, props: CognitoProps?): Cognito_sim
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight adminConfirmUser(email: str): void</code> | *No description* |
| <code>connect(path: str): void</code> | *No description* |
| <code>delete(path: str): void</code> | *No description* |
| <code>get(path: str): void</code> | *No description* |
| <code>inflight getCredentialsForIdentity(token: str, identityId: str): Json</code> | *No description* |
| <code>inflight getId(poolId: str, identityPoolId: str, token: str): str</code> | *No description* |
| <code>head(path: str): void</code> | *No description* |
| <code>inflight initiateAuth(email: str, password: str): str</code> | *No description* |
| <code>options(path: str): void</code> | *No description* |
| <code>patch(path: str): void</code> | *No description* |
| <code>post(path: str): void</code> | *No description* |
| <code>put(path: str): void</code> | *No description* |
| <code>inflight signUp(email: str, password: str): void</code> | *No description* |

### ICognito (interface) <a class="wing-docs-anchor" id="@winglibs/cognito.ICognito"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight adminConfirmUser(email: str): void</code> | *No description* |
| <code>connect(path: str): void</code> | *No description* |
| <code>delete(path: str): void</code> | *No description* |
| <code>get(path: str): void</code> | *No description* |
| <code>inflight getCredentialsForIdentity(token: str, identityId: str): Json</code> | *No description* |
| <code>inflight getId(poolId: str, identityPoolId: str, token: str): str</code> | *No description* |
| <code>head(path: str): void</code> | *No description* |
| <code>inflight initiateAuth(email: str, password: str): str</code> | *No description* |
| <code>options(path: str): void</code> | *No description* |
| <code>patch(path: str): void</code> | *No description* |
| <code>post(path: str): void</code> | *No description* |
| <code>put(path: str): void</code> | *No description* |
| <code>inflight signUp(email: str, password: str): void</code> | *No description* |

### CognitoProps (struct) <a class="wing-docs-anchor" id="@winglibs/cognito.CognitoProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>authenticationType</code> | <code>AuthenticationType?</code> | *No description* |
| <code>autoVerifiedAttributes</code> | <code>Array<str>?</code> | *No description* |
| <code>headerKey</code> | <code>str?</code> | *No description* |
| <code>name</code> | <code>str?</code> | *No description* |
| <code>schema</code> | <code>Json?</code> | *No description* |
| <code>usernameAttributes</code> | <code>Array<str>?</code> | *No description* |

### AuthenticationType (enum) <a class="wing-docs-anchor" id="@winglibs/cognito.AuthenticationType"></a>

*No description*

#### Values

| **Name** | **Description** |
| --- | --- |
| <code>AWS_IAM</code> | *No description* |
| <code>COGNITO_USER_POOLS</code> | *No description* |

