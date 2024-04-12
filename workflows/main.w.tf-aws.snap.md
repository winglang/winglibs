# `main.w.tf-aws.snap.md`

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
      "Workflow_role_1483EA57": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/role",
            "uniqueId": "Workflow_role_1483EA57"
          }
        },
        "assume_role_policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"states.amazonaws.com\"}}]}",
        "inline_policy": [
        ]
      }
    },
    "aws_sfn_state_machine": {
      "Workflow_state_machine_224328AB": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/state_machine",
            "uniqueId": "Workflow_state_machine_224328AB"
          }
        },
        "definition": "{\"StartAt\":\"End\",\"States\":{}}",
        "role_arn": "${aws_iam_role.Workflow_role_1483EA57.arn}"
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
