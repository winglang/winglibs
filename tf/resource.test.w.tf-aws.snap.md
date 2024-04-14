# `resource.test.w.tf-aws.snap.md`

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
    ]
  },
  "resource": {
    "aws_iam_role": {
      "my_role": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/my_role",
            "uniqueId": "my_role"
          }
        },
        "assume_role_policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"states.amazonaws.com\"}}]}",
        "inline_policy": {
          "name": "lambda-invoke",
          "policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"lambda:InvokeFunction\"],\"Resource\":\"*\"}]}"
        }
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
      }
    }
  }
}
```
