<h2>API Reference</h2>

<h3>Table of Contents</h3>

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

<h3 id="@winglibs/ses.EmailService_tfaws">EmailService_tfaws (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: EmailServiceProps): EmailService_tfaws
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight sendEmail(options: SendEmailOptions): str?</code> | *No description* |
| <code>inflight sendRawEmail(options: SendRawEmailOptions): str?</code> | *No description* |

<h3 id="@winglibs/ses.EmailService_sim">EmailService_sim (preflight class)</h3>

<h4>Constructor</h4>

<pre>
new(props: EmailServiceProps): EmailService_sim
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight sendEmail(options: SendEmailOptions): str?</code> | *No description* |
| <code>inflight sendRawEmail(options: SendRawEmailOptions): str?</code> | *No description* |

<h3 id="@winglibs/ses.EmailService">EmailService (preflight class)</h3>

EmailService can used for defining and interacting with AWS SES.
When running the simulator in a non test environment, it will use the
actual cloud implementation.

<h4>Constructor</h4>

<pre>
new(props: EmailServiceProps): EmailService
</pre>

<h4>Properties</h4>

*No properties*

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight sendEmail(options: SendEmailOptions): str?</code> | *No description* |
| <code>inflight sendRawEmail(options: SendRawEmailOptions): str?</code> | *No description* |

<h3 id="@winglibs/ses.IEmailService">IEmailService (interface)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>node</code> | <code>Node</code> | The tree node. |

<h4>Methods</h4>

| **Signature** | **Description** |
| --- | --- |
| <code>inflight sendEmail(options: SendEmailOptions): str?</code> | *No description* |
| <code>inflight sendRawEmail(options: SendRawEmailOptions): str?</code> | *No description* |

<h3 id="@winglibs/ses.Body">Body (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Html</code> | <code>Content?</code> | *No description* |
| <code>Text</code> | <code>Content?</code> | *No description* |

<h3 id="@winglibs/ses.CloudWatchDestination">CloudWatchDestination (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>defaultValue</code> | <code>str</code> | *No description* |
| <code>dimensionName</code> | <code>str</code> | *No description* |
| <code>valueSource</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/ses.ConfigurationSet">ConfigurationSet (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>name</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/ses.Content">Content (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Data</code> | <code>str?</code> | *No description* |

<h3 id="@winglibs/ses.Destination">Destination (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>BccAddresses</code> | <code>Array<str>?</code> | *No description* |
| <code>CcAddresses</code> | <code>Array<str>?</code> | *No description* |
| <code>ToAddresses</code> | <code>Array<str>?</code> | *No description* |

<h3 id="@winglibs/ses.EmailServiceProps">EmailServiceProps (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>configurationSet</code> | <code>ConfigurationSet?</code> | *No description* |
| <code>emailIdentities</code> | <code>Array<str>?</code> | *No description* |
| <code>eventDestination</code> | <code>EventDestination?</code> | *No description* |

<h3 id="@winglibs/ses.EventDestination">EventDestination (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>cloudwatchDestination</code> | <code>CloudWatchDestination?</code> | *No description* |
| <code>matchingTypes</code> | <code>Array<str></code> | *No description* |
| <code>name</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/ses.Message">Message (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Body</code> | <code>Body?</code> | *No description* |
| <code>Subject</code> | <code>Content?</code> | *No description* |

<h3 id="@winglibs/ses.RawMessage">RawMessage (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Data</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/ses.SendEmailOptions">SendEmailOptions (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Destination</code> | <code>Destination?</code> | *No description* |
| <code>Message</code> | <code>Message?</code> | *No description* |
| <code>Source</code> | <code>str</code> | *No description* |

<h3 id="@winglibs/ses.SendRawEmailOptions">SendRawEmailOptions (struct)</h3>

<h4>Properties</h4>

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>Destinations</code> | <code>Array<str>?</code> | *No description* |
| <code>RawMessage</code> | <code>RawMessage</code> | *No description* |
| <code>Source</code> | <code>str?</code> | *No description* |

