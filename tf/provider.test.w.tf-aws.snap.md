# `provider.test.w.tf-aws.snap.md`

## main.tf.json

```json
{
  "//": {
    "metadata": {
      "backend": "local",
      "stackName": "root",
      "version": "0.20.3"
    },
    "outputs": {
    }
  },
  "provider": {
    "aws": [
      {
      }
    ],
    "dnsimple": [
      {
        "token": "dnsimple_token"
      }
    ]
  },
  "terraform": {
    "backend": {
      "local": {
        "path": "./terraform.tfstate"
      }
    },
    "required_providers": {
      "aws": {
        "source": "aws",
        "version": "5.31.0"
      },
      "dnsimple": {
        "source": "dnsimple/dnsimple",
        "version": "1.6.0"
      }
    }
  }
}
```
