# `cache.test.w.tf-aws.snap.md`

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
    "momento": [
      {
      }
    ]
  },
  "resource": {
    "momento_cache": {
      "WinglyCache2_Cache_tf_BFD39D76": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/WinglyCache2/Cache_tf/Resource",
            "uniqueId": "WinglyCache2_Cache_tf_BFD39D76"
          }
        },
        "name": "WinglyCa_336e9df3"
      },
      "WinglyCache_Cache_tf_E4453786": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/WinglyCache/Cache_tf/Resource",
            "uniqueId": "WinglyCache_Cache_tf_E4453786"
          }
        },
        "name": "WinglyCa_c62abd14"
      }
    }
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
      "momento": {
        "source": "Chriscbr/momento",
        "version": "0.1.2"
      }
    }
  }
}
```
