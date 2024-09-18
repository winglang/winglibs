## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/email.Email">Email</a>
- **Interfaces**
  - <a href="#@winglibs/email.IEmail">IEmail</a>
- **Structs**
  - <a href="#@winglibs/email.EmailProps">EmailProps</a>
  - <a href="#@winglibs/email.SendEmailOptions">SendEmailOptions</a>

### Email (preflight class) <a class="wing-docs-anchor" id="@winglibs/email.Email"></a>

*No description*

#### Constructor

```
new(props: EmailProps): Email
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight send(options: SendEmailOptions): void</code> | *No description* |

### IEmail (interface) <a class="wing-docs-anchor" id="@winglibs/email.IEmail"></a>

*No description*

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>inflight send(options: SendEmailOptions): void</code> | Sends a simple email. |

### EmailProps (struct) <a class="wing-docs-anchor" id="@winglibs/email.EmailProps"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>sender</code> | <code>str</code> | The email address for the sender of all emails. |

### SendEmailOptions (struct) <a class="wing-docs-anchor" id="@winglibs/email.SendEmailOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>html</code> | <code>str?</code> | The body of the email, in HTML. @default - The text body will be used as the HTML body. |
| <code>subject</code> | <code>str</code> | The subject of the email. |
| <code>text</code> | <code>str</code> | The body of the email, in plain text. |
| <code>to</code> | <code>Array<str></code> | The email addresses to send the email to. |

