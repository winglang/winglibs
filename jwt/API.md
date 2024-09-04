## API Reference

### Table of Contents

- **Classes**
  - <a href="#@winglibs/jwt.Util">Util</a>
- **Structs**
  - <a href="#@winglibs/jwt.DecodeOptions">DecodeOptions</a>
  - <a href="#@winglibs/jwt.SignOptions">SignOptions</a>
  - <a href="#@winglibs/jwt.VerifyJwtOptions">VerifyJwtOptions</a>
  - <a href="#@winglibs/jwt.VerifyOptions">VerifyOptions</a>

### Util (preflight class) <a class="wing-docs-anchor" id="@winglibs/jwt.Util"></a>

*No description*

#### Constructor

```
new(): Util
```

#### Properties

*No properties*

#### Methods

| **Signature** | **Description** |
| --- | --- |
| <code>static inflight decode(token: str, options: DecodeOptions?): Json</code> | *No description* |
| <code>static inflight sign(data: Json, secret: str, options: SignOptions?): str</code> | *No description* |
| <code>static inflight verify(token: str, options: VerifyOptions): Json</code> | *No description* |

### DecodeOptions (struct) <a class="wing-docs-anchor" id="@winglibs/jwt.DecodeOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>complete</code> | <code>bool?</code> | *No description* |

### SignOptions (struct) <a class="wing-docs-anchor" id="@winglibs/jwt.SignOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>algorithm</code> | <code>str?</code> | *No description* |
| <code>audience</code> | <code>Array<str>?</code> | *No description* |
| <code>encoding</code> | <code>str?</code> | *No description* |
| <code>expiresIn</code> | <code>duration?</code> | *No description* |
| <code>issuer</code> | <code>str?</code> | *No description* |
| <code>jwtid</code> | <code>str?</code> | *No description* |
| <code>keyid</code> | <code>str?</code> | *No description* |
| <code>notBefore</code> | <code>duration?</code> | *No description* |
| <code>subject</code> | <code>str?</code> | *No description* |

### VerifyJwtOptions (struct) <a class="wing-docs-anchor" id="@winglibs/jwt.VerifyJwtOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>algorithms</code> | <code>Array<str>?</code> | *No description* |
| <code>audience</code> | <code>str?</code> | *No description* |
| <code>ignoreExpiration</code> | <code>bool?</code> | *No description* |
| <code>ignoreNotBefore</code> | <code>bool?</code> | *No description* |
| <code>issuer</code> | <code>str?</code> | *No description* |
| <code>jwtid</code> | <code>str?</code> | *No description* |
| <code>maxAge</code> | <code>str?</code> | *No description* |
| <code>nonce</code> | <code>str?</code> | *No description* |
| <code>subject</code> | <code>str?</code> | *No description* |

### VerifyOptions (struct) <a class="wing-docs-anchor" id="@winglibs/jwt.VerifyOptions"></a>

*No description*

#### Properties

| **Name** | **Type** | **Description** |
| --- | --- | --- |
| <code>jwksUri</code> | <code>str?</code> | *No description* |
| <code>options</code> | <code>VerifyJwtOptions?</code> | *No description* |
| <code>secret</code> | <code>str?</code> | *No description* |

