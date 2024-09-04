## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/ses.EmailService_tfaws">EmailService_tfaws</a>
  - <a href="#@winglibs/ses.EmailService_sim">EmailService_sim</a>
  - <a href="#@winglibs/ses.EmailService">EmailService</a>
- **Interfaces**
  - <a href="#@winglibs/ses.IEmailService">IEmailService</a>
- **Structs**
  - <a href="#@winglibs/ses.Body">Body</a>
  - <a href="#@winglibs/ses.CloudWatchDestination">CloudWatchDestination</a>
  - <a href="#@winglibs/ses.ConfigurationSet">ConfigurationSet</a>
  - <a href="#@winglibs/ses.Content">Content</a>
  - <a href="#@winglibs/ses.Destination">Destination</a>
  - <a href="#@winglibs/ses.EmailServiceProps">EmailServiceProps</a>
  - <a href="#@winglibs/ses.EventDestination">EventDestination</a>
  - <a href="#@winglibs/ses.Message">Message</a>
  - <a href="#@winglibs/ses.RawMessage">RawMessage</a>
  - <a href="#@winglibs/ses.SendEmailOptions">SendEmailOptions</a>
  - <a href="#@winglibs/ses.SendRawEmailOptions">SendRawEmailOptions</a>

### EmailService_tfaws (preflight class) <a class="wing-docs-anchor" id="@winglibs/ses.EmailService_tfaws"></a>

*No description*

#### Constructor

```
new(props: EmailServiceProps): EmailService_tfaws
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight sendEmail(options: SendEmailOptions): str?</code> | *No description* |
| <code>inflight sendRawEmail(options: SendRawEmailOptions): str?</code> | *No description* |

### EmailService_sim (preflight class) <a class="wing-docs-anchor" id="@winglibs/ses.EmailService_sim"></a>

*No description*

#### Constructor

```
new(props: EmailServiceProps): EmailService_sim
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight sendEmail(options: SendEmailOptions): str?</code> | *No description* |
| <code>inflight sendRawEmail(options: SendRawEmailOptions): str?</code> | *No description* |

### EmailService (preflight class) <a class="wing-docs-anchor" id="@winglibs/ses.EmailService"></a>

EmailService can used for defining and interacting with AWS SES.
When running the simulator in a non test environment, it will use the
actual cloud implementation.

#### Constructor

```
new(props: EmailServiceProps): EmailService
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight sendEmail(options: SendEmailOptions): str?</code> | *No description* |
| <code>inflight sendRawEmail(options: SendRawEmailOptions): str?</code> | *No description* |

### IEmailService (interface) <a class="wing-docs-anchor" id="@winglibs/ses.IEmailService"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>node</code> | <code>Node</code> | The tree node. |

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight sendEmail(options: SendEmailOptions): str?</code> | *No description* |
| <code>inflight sendRawEmail(options: SendRawEmailOptions): str?</code> | *No description* |

### Body (struct) <a class="wing-docs-anchor" id="@winglibs/ses.Body"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Html</code> | <code>Content?</code> | *No description* |
| <code>Text</code> | <code>Content?</code> | *No description* |

### CloudWatchDestination (struct) <a class="wing-docs-anchor" id="@winglibs/ses.CloudWatchDestination"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>defaultValue</code> | <code>str</code> | *No description* |
| <code>dimensionName</code> | <code>str</code> | *No description* |
| <code>valueSource</code> | <code>str</code> | *No description* |

### ConfigurationSet (struct) <a class="wing-docs-anchor" id="@winglibs/ses.ConfigurationSet"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>name</code> | <code>str</code> | *No description* |

### Content (struct) <a class="wing-docs-anchor" id="@winglibs/ses.Content"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Data</code> | <code>str?</code> | *No description* |

### Destination (struct) <a class="wing-docs-anchor" id="@winglibs/ses.Destination"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>BccAddresses</code> | <code>Array<str>?</code> | *No description* |
| <code>CcAddresses</code> | <code>Array<str>?</code> | *No description* |
| <code>ToAddresses</code> | <code>Array<str>?</code> | *No description* |

### EmailServiceProps (struct) <a class="wing-docs-anchor" id="@winglibs/ses.EmailServiceProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>configurationSet</code> | <code>ConfigurationSet?</code> | *No description* |
| <code>emailIdentities</code> | <code>Array<str>?</code> | *No description* |
| <code>eventDestination</code> | <code>EventDestination?</code> | *No description* |

### EventDestination (struct) <a class="wing-docs-anchor" id="@winglibs/ses.EventDestination"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>cloudwatchDestination</code> | <code>CloudWatchDestination?</code> | *No description* |
| <code>matchingTypes</code> | <code>Array<str></code> | *No description* |
| <code>name</code> | <code>str</code> | *No description* |

### Message (struct) <a class="wing-docs-anchor" id="@winglibs/ses.Message"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Body</code> | <code>Body?</code> | *No description* |
| <code>Subject</code> | <code>Content?</code> | *No description* |

### RawMessage (struct) <a class="wing-docs-anchor" id="@winglibs/ses.RawMessage"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Data</code> | <code>str</code> | *No description* |

### SendEmailOptions (struct) <a class="wing-docs-anchor" id="@winglibs/ses.SendEmailOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Destination</code> | <code>Destination?</code> | *No description* |
| <code>Message</code> | <code>Message?</code> | *No description* |
| <code>Source</code> | <code>str</code> | *No description* |

### SendRawEmailOptions (struct) <a class="wing-docs-anchor" id="@winglibs/ses.SendRawEmailOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Destinations</code> | <code>Array<str>?</code> | *No description* |
| <code>RawMessage</code> | <code>RawMessage</code> | *No description* |
| <code>Source</code> | <code>str?</code> | *No description* |

