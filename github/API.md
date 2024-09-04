## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/github.ProbotApp">ProbotApp</a>
  - <a href="#@winglibs/github.utils.LowkeysMap">utils.LowkeysMap</a>
  - <a href="#@winglibs/github.simutils.Port">simutils.Port</a>
  - <a href="#@winglibs/github.simutils.Service">simutils.Service</a>
  - <a href="#@winglibs/github.probot.ProbotAdapter">probot.ProbotAdapter</a>
  - <a href="#@winglibs/github.ngrok.Ngrok">ngrok.Ngrok</a>
- **Interfaces**
  - <a href="#@winglibs/github.IProbotAppCredentialsSupplier">IProbotAppCredentialsSupplier</a>
  - <a href="#@winglibs/github.simutils.Process">simutils.Process</a>
  - <a href="#@winglibs/github.probot.IProbotAuth">probot.IProbotAuth</a>
  - <a href="#@winglibs/github.probot.IProbotWebhooks">probot.IProbotWebhooks</a>
  - <a href="#@winglibs/github.probot.IProbotAppCredentialsSupplier">probot.IProbotAppCredentialsSupplier</a>
- **Structs**
  - <a href="#@winglibs/github.ProbotAppProps">ProbotAppProps</a>
  - <a href="#@winglibs/github.simutils.ServiceProps">simutils.ServiceProps</a>
  - <a href="#@winglibs/github.probot.Context">probot.Context</a>
  - <a href="#@winglibs/github.probot.ProbotInstance">probot.ProbotInstance</a>
  - <a href="#@winglibs/github.probot.PullRequestClosedContext">probot.PullRequestClosedContext</a>
  - <a href="#@winglibs/github.probot.PullRequestContext">probot.PullRequestContext</a>
  - <a href="#@winglibs/github.probot.PullRequestOpenedContext">probot.PullRequestOpenedContext</a>
  - <a href="#@winglibs/github.probot.PullRequestSyncContext">probot.PullRequestSyncContext</a>
  - <a href="#@winglibs/github.probot.PushContext">probot.PushContext</a>
  - <a href="#@winglibs/github.probot.VerifyAndReceieveProps">probot.VerifyAndReceieveProps</a>
  - <a href="#@winglibs/github.probot.CreateAdapterOptions">probot.CreateAdapterOptions</a>
  - <a href="#@winglibs/github.probot.ProbotAdapterProps">probot.ProbotAdapterProps</a>
  - <a href="#@winglibs/github.octokit.CompareCommitsProps">octokit.CompareCommitsProps</a>
  - <a href="#@winglibs/github.octokit.CompareCommitsResponse">octokit.CompareCommitsResponse</a>
  - <a href="#@winglibs/github.octokit.CompareCommitsResponseCommit">octokit.CompareCommitsResponseCommit</a>
  - <a href="#@winglibs/github.octokit.CompareCommitsResponseData">octokit.CompareCommitsResponseData</a>
  - <a href="#@winglibs/github.octokit.CompareCommitsResponseFile">octokit.CompareCommitsResponseFile</a>
  - <a href="#@winglibs/github.octokit.GetCommitProps">octokit.GetCommitProps</a>
  - <a href="#@winglibs/github.octokit.GetCommitResponse">octokit.GetCommitResponse</a>
  - <a href="#@winglibs/github.octokit.GetCommitResponseData">octokit.GetCommitResponseData</a>
  - <a href="#@winglibs/github.octokit.GetCommitResponseFile">octokit.GetCommitResponseFile</a>
  - <a href="#@winglibs/github.octokit.GetContentProps">octokit.GetContentProps</a>
  - <a href="#@winglibs/github.octokit.GetContentResponse">octokit.GetContentResponse</a>
  - <a href="#@winglibs/github.octokit.GetContentResponseData">octokit.GetContentResponseData</a>
  - <a href="#@winglibs/github.octokit.ListReposResponse">octokit.ListReposResponse</a>
  - <a href="#@winglibs/github.octokit.OctoKit">octokit.OctoKit</a>
  - <a href="#@winglibs/github.ngrok.NgrokProps">ngrok.NgrokProps</a>

### ProbotApp (preflight class) <a class="wing-docs-anchor" id="@winglibs/github.ProbotApp"></a>

*No description*

#### Constructor

```
new(props: ProbotAppProps): ProbotApp
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>static inflight createGithubAppJwt(appId: str, privateKey: str): str</code> | *No description* |
| <code>onPullRequestOpened(handler: inflight (PullRequestOpenedContext): void): void</code> | *No description* |
| <code>onPullRequestReopened(handler: inflight (PullRequestOpenedContext): void): void</code> | *No description* |
| <code>inflight updateWebhookUrl(url: str): void</code> | *No description* |

### utils.LowkeysMap (inflight class) <a class="wing-docs-anchor" id="@winglibs/github.utils.LowkeysMap"></a>

*No description*

#### Constructor

```
new(): LowkeysMap
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>static inflight fromMap(map: Map<str>): Map<str></code> | *No description* |

### simutils.Port (preflight class) <a class="wing-docs-anchor" id="@winglibs/github.simutils.Port"></a>

*No description*

#### Constructor

```
new(): Port
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>port</code> | <code>str</code> | *No description* |

#### Methods

*No methods*

### simutils.Service (preflight class) <a class="wing-docs-anchor" id="@winglibs/github.simutils.Service"></a>

*No description*

#### Constructor

```
new(command: str, args: Array<str>, props: ServiceProps): Service
```

#### Properties

*No properties*

#### Methods

*No methods*

### probot.ProbotAdapter (preflight class) <a class="wing-docs-anchor" id="@winglibs/github.probot.ProbotAdapter"></a>

*No description*

#### Constructor

```
new(props: ProbotAdapterProps): ProbotAdapter
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight auth(installationId: num): OctoKit</code> | *No description* |
| <code>static inflight createProbotAdapter(options: CreateAdapterOptions): ProbotInstance</code> | *No description* |
| <code>inflight handlePullRequstClosed(handler: inflight (PullRequestClosedContext): void): void</code> | *No description* |
| <code>inflight handlePullRequstOpened(handler: inflight (PullRequestOpenedContext): void): void</code> | *No description* |
| <code>inflight handlePullRequstReopened(handler: inflight (PullRequestOpenedContext): void): void</code> | *No description* |
| <code>inflight handlePullRequstSync(handler: inflight (PullRequestSyncContext): void): void</code> | *No description* |
| <code>inflight handlePush(handler: inflight (PushContext): void): void</code> | *No description* |
| <code>inflight verifyAndReceive(props: VerifyAndReceieveProps): void</code> | *No description* |

### ngrok.Ngrok (preflight class) <a class="wing-docs-anchor" id="@winglibs/github.ngrok.Ngrok"></a>

*No description*

#### Constructor

```
new(props: NgrokProps): Ngrok
```

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>url</code> | <code>str</code> | *No description* |

#### Methods

*No methods*

### IProbotAppCredentialsSupplier (interface) <a class="wing-docs-anchor" id="@winglibs/github.IProbotAppCredentialsSupplier"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight getId(): str</code> | *No description* |
| <code>inflight getPrivateKey(): str</code> | *No description* |
| <code>inflight getWebhookSecret(): str</code> | *No description* |

### simutils.Process (interface) <a class="wing-docs-anchor" id="@winglibs/github.simutils.Process"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight kill(): void</code> | *No description* |

### probot.IProbotAuth (interface) <a class="wing-docs-anchor" id="@winglibs/github.probot.IProbotAuth"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight call(instance: ProbotInstance, installationId: num): OctoKit</code> | *No description* |

### probot.IProbotWebhooks (interface) <a class="wing-docs-anchor" id="@winglibs/github.probot.IProbotWebhooks"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight on(name: str, handler: inflight (): void): void</code> | *No description* |
| <code>inflight verifyAndReceive(props: VerifyAndReceieveProps): void</code> | *No description* |

### probot.IProbotAppCredentialsSupplier (interface) <a class="wing-docs-anchor" id="@winglibs/github.probot.IProbotAppCredentialsSupplier"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight getId(): str</code> | *No description* |
| <code>inflight getPrivateKey(): str</code> | *No description* |
| <code>inflight getWebhookSecret(): str</code> | *No description* |

### ProbotAppProps (struct) <a class="wing-docs-anchor" id="@winglibs/github.ProbotAppProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>credentialsSupplier</code> | <code>IProbotAppCredentialsSupplier</code> | *No description* |

### simutils.ServiceProps (struct) <a class="wing-docs-anchor" id="@winglibs/github.simutils.ServiceProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>cwd</code> | <code>str?</code> | *No description* |
| <code>env</code> | <code>Map<str>?</code> | *No description* |

### probot.Context (struct) <a class="wing-docs-anchor" id="@winglibs/github.probot.Context"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>id</code> | <code>str</code> | *No description* |
| <code>octokit</code> | <code>OctoKit</code> | *No description* |

### probot.ProbotInstance (struct) <a class="wing-docs-anchor" id="@winglibs/github.probot.ProbotInstance"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>auth</code> | <code>IProbotAuth</code> | *No description* |
| <code>webhooks</code> | <code>IProbotWebhooks</code> | *No description* |

### probot.PullRequestClosedContext (struct) <a class="wing-docs-anchor" id="@winglibs/github.probot.PullRequestClosedContext"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>id</code> | <code>str</code> | *No description* |
| <code>octokit</code> | <code>OctoKit</code> | *No description* |
| <code>payload</code> | <code>PullRequestPayload</code> | *No description* |

### probot.PullRequestContext (struct) <a class="wing-docs-anchor" id="@winglibs/github.probot.PullRequestContext"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>id</code> | <code>str</code> | *No description* |
| <code>octokit</code> | <code>OctoKit</code> | *No description* |
| <code>payload</code> | <code>PullRequestPayload</code> | *No description* |

### probot.PullRequestOpenedContext (struct) <a class="wing-docs-anchor" id="@winglibs/github.probot.PullRequestOpenedContext"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>id</code> | <code>str</code> | *No description* |
| <code>octokit</code> | <code>OctoKit</code> | *No description* |
| <code>payload</code> | <code>PullRequestPayload</code> | *No description* |

### probot.PullRequestSyncContext (struct) <a class="wing-docs-anchor" id="@winglibs/github.probot.PullRequestSyncContext"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>id</code> | <code>str</code> | *No description* |
| <code>octokit</code> | <code>OctoKit</code> | *No description* |
| <code>payload</code> | <code>PullRequestPayload</code> | *No description* |

### probot.PushContext (struct) <a class="wing-docs-anchor" id="@winglibs/github.probot.PushContext"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>id</code> | <code>str</code> | *No description* |
| <code>octokit</code> | <code>OctoKit</code> | *No description* |
| <code>payload</code> | <code>PushPayload</code> | *No description* |

### probot.VerifyAndReceieveProps (struct) <a class="wing-docs-anchor" id="@winglibs/github.probot.VerifyAndReceieveProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>id</code> | <code>str</code> | *No description* |
| <code>name</code> | <code>str</code> | *No description* |
| <code>payload</code> | <code>str</code> | *No description* |
| <code>signature</code> | <code>str</code> | *No description* |

### probot.CreateAdapterOptions (struct) <a class="wing-docs-anchor" id="@winglibs/github.probot.CreateAdapterOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>appId</code> | <code>str</code> | *No description* |
| <code>privateKey</code> | <code>str</code> | *No description* |
| <code>webhookSecret</code> | <code>str</code> | *No description* |

### probot.ProbotAdapterProps (struct) <a class="wing-docs-anchor" id="@winglibs/github.probot.ProbotAdapterProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>credentialsSupplier</code> | <code>IProbotAppCredentialsSupplier</code> | *No description* |

### octokit.CompareCommitsProps (struct) <a class="wing-docs-anchor" id="@winglibs/github.octokit.CompareCommitsProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>base</code> | <code>str</code> | *No description* |
| <code>head</code> | <code>str</code> | *No description* |
| <code>owner</code> | <code>str</code> | *No description* |
| <code>repo</code> | <code>str</code> | *No description* |

### octokit.CompareCommitsResponse (struct) <a class="wing-docs-anchor" id="@winglibs/github.octokit.CompareCommitsResponse"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>data</code> | <code>CompareCommitsResponseData</code> | *No description* |

### octokit.CompareCommitsResponseCommit (struct) <a class="wing-docs-anchor" id="@winglibs/github.octokit.CompareCommitsResponseCommit"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>sha</code> | <code>str</code> | *No description* |

### octokit.CompareCommitsResponseData (struct) <a class="wing-docs-anchor" id="@winglibs/github.octokit.CompareCommitsResponseData"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>commits</code> | <code>Array<CompareCommitsResponseCommit></code> | *No description* |

### octokit.CompareCommitsResponseFile (struct) <a class="wing-docs-anchor" id="@winglibs/github.octokit.CompareCommitsResponseFile"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>filaname</code> | <code>str</code> | *No description* |
| <code>sha</code> | <code>str</code> | *No description* |

### octokit.GetCommitProps (struct) <a class="wing-docs-anchor" id="@winglibs/github.octokit.GetCommitProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>owner</code> | <code>str</code> | *No description* |
| <code>ref</code> | <code>str</code> | *No description* |
| <code>repo</code> | <code>str</code> | *No description* |

### octokit.GetCommitResponse (struct) <a class="wing-docs-anchor" id="@winglibs/github.octokit.GetCommitResponse"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>data</code> | <code>GetCommitResponseData</code> | *No description* |

### octokit.GetCommitResponseData (struct) <a class="wing-docs-anchor" id="@winglibs/github.octokit.GetCommitResponseData"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>files</code> | <code>Array<GetCommitResponseFile>?</code> | *No description* |

### octokit.GetCommitResponseFile (struct) <a class="wing-docs-anchor" id="@winglibs/github.octokit.GetCommitResponseFile"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>filename</code> | <code>str</code> | *No description* |
| <code>sha</code> | <code>str</code> | *No description* |
| <code>status</code> | <code>str</code> | *No description* |

### octokit.GetContentProps (struct) <a class="wing-docs-anchor" id="@winglibs/github.octokit.GetContentProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>owner</code> | <code>str</code> | *No description* |
| <code>path</code> | <code>str</code> | *No description* |
| <code>ref</code> | <code>str?</code> | *No description* |
| <code>repo</code> | <code>str</code> | *No description* |

### octokit.GetContentResponse (struct) <a class="wing-docs-anchor" id="@winglibs/github.octokit.GetContentResponse"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>data</code> | <code>GetContentResponseData</code> | *No description* |
| <code>status</code> | <code>num</code> | *No description* |

### octokit.GetContentResponseData (struct) <a class="wing-docs-anchor" id="@winglibs/github.octokit.GetContentResponseData"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>content</code> | <code>str?</code> | *No description* |
| <code>name</code> | <code>str</code> | *No description* |
| <code>path</code> | <code>str</code> | *No description* |
| <code>sha</code> | <code>str</code> | *No description* |
| <code>size</code> | <code>num</code> | *No description* |
| <code>type</code> | <code>str</code> | *No description* |

### octokit.ListReposResponse (struct) <a class="wing-docs-anchor" id="@winglibs/github.octokit.ListReposResponse"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>data</code> | <code>Array<ListReposResponseData></code> | *No description* |
| <code>status</code> | <code>num</code> | *No description* |

### octokit.OctoKit (struct) <a class="wing-docs-anchor" id="@winglibs/github.octokit.OctoKit"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>apps</code> | <code>OctoKitApps</code> | *No description* |
| <code>git</code> | <code>OctoKitGit</code> | *No description* |
| <code>issues</code> | <code>OctoKitIssues</code> | *No description* |
| <code>pulls</code> | <code>OctoKitPulls</code> | *No description* |
| <code>repos</code> | <code>OctoKitRepos</code> | *No description* |

### ngrok.NgrokProps (struct) <a class="wing-docs-anchor" id="@winglibs/github.ngrok.NgrokProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>domain</code> | <code>str?</code> | *No description* |
| <code>url</code> | <code>str</code> | *No description* |

