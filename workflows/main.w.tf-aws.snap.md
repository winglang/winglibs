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
    "aws_cloudwatch_log_group": {
      "Workflow_getnamefrombucket_CloudwatchLogGroup_1267CC16": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/get name from bucket/CloudwatchLogGroup",
            "uniqueId": "Workflow_getnamefrombucket_CloudwatchLogGroup_1267CC16"
          }
        },
        "name": "/aws/lambda/get-name-from-bucket-c8b7dd00",
        "retention_in_days": 30
      },
      "Workflow_hasname_CloudwatchLogGroup_B10C7663": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/has name?/CloudwatchLogGroup",
            "uniqueId": "Workflow_hasname_CloudwatchLogGroup_B10C7663"
          }
        },
        "name": "/aws/lambda/has-name--c84b2e93",
        "retention_in_days": 30
      },
      "Workflow_putnameinbucket_CloudwatchLogGroup_07259E5D": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/put name in bucket/CloudwatchLogGroup",
            "uniqueId": "Workflow_putnameinbucket_CloudwatchLogGroup_07259E5D"
          }
        },
        "name": "/aws/lambda/put-name-in-bucket-c85c34a8",
        "retention_in_days": 30
      }
    },
    "aws_iam_role": {
      "Workflow_getnamefrombucket_IamRole_C3A26695": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/get name from bucket/IamRole",
            "uniqueId": "Workflow_getnamefrombucket_IamRole_C3A26695"
          }
        },
        "assume_role_policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Effect\":\"Allow\"}]}"
      },
      "Workflow_hasname_IamRole_CFA5F101": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/has name?/IamRole",
            "uniqueId": "Workflow_hasname_IamRole_CFA5F101"
          }
        },
        "assume_role_policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Effect\":\"Allow\"}]}"
      },
      "Workflow_putnameinbucket_IamRole_F8FA413B": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/put name in bucket/IamRole",
            "uniqueId": "Workflow_putnameinbucket_IamRole_F8FA413B"
          }
        },
        "assume_role_policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Effect\":\"Allow\"}]}"
      },
      "Workflow_role_1483EA57": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/role",
            "uniqueId": "Workflow_role_1483EA57"
          }
        },
        "assume_role_policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"states.amazonaws.com\"}}]}",
        "inline_policy": {
          "name": "lambda-invoke",
          "policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"lambda:InvokeFunction\"],\"Resource\":\"*\"}]}"
        }
      }
    },
    "aws_iam_role_policy": {
      "Workflow_getnamefrombucket_IamRolePolicy_BBCA9ECF": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/get name from bucket/IamRolePolicy",
            "uniqueId": "Workflow_getnamefrombucket_IamRolePolicy_BBCA9ECF"
          }
        },
        "policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"s3:List*\",\"s3:GetObject*\",\"s3:GetBucket*\"],\"Resource\":[\"${aws_s3_bucket.Bucket.arn}\",\"${aws_s3_bucket.Bucket.arn}/*\"],\"Effect\":\"Allow\"}]}",
        "role": "${aws_iam_role.Workflow_getnamefrombucket_IamRole_C3A26695.name}"
      },
      "Workflow_hasname_IamRolePolicy_DFFECF14": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/has name?/IamRolePolicy",
            "uniqueId": "Workflow_hasname_IamRolePolicy_DFFECF14"
          }
        },
        "policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":\"none:null\",\"Resource\":\"*\"}]}",
        "role": "${aws_iam_role.Workflow_hasname_IamRole_CFA5F101.name}"
      },
      "Workflow_putnameinbucket_IamRolePolicy_AD3FB35B": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/put name in bucket/IamRolePolicy",
            "uniqueId": "Workflow_putnameinbucket_IamRolePolicy_AD3FB35B"
          }
        },
        "policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"s3:PutObject*\",\"s3:Abort*\"],\"Resource\":[\"${aws_s3_bucket.Bucket.arn}\",\"${aws_s3_bucket.Bucket.arn}/*\"],\"Effect\":\"Allow\"}]}",
        "role": "${aws_iam_role.Workflow_putnameinbucket_IamRole_F8FA413B.name}"
      }
    },
    "aws_iam_role_policy_attachment": {
      "Workflow_getnamefrombucket_IamRolePolicyAttachment_1158475A": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/get name from bucket/IamRolePolicyAttachment",
            "uniqueId": "Workflow_getnamefrombucket_IamRolePolicyAttachment_1158475A"
          }
        },
        "policy_arn": "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
        "role": "${aws_iam_role.Workflow_getnamefrombucket_IamRole_C3A26695.name}"
      },
      "Workflow_hasname_IamRolePolicyAttachment_4AD81505": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/has name?/IamRolePolicyAttachment",
            "uniqueId": "Workflow_hasname_IamRolePolicyAttachment_4AD81505"
          }
        },
        "policy_arn": "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
        "role": "${aws_iam_role.Workflow_hasname_IamRole_CFA5F101.name}"
      },
      "Workflow_putnameinbucket_IamRolePolicyAttachment_7062B349": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/put name in bucket/IamRolePolicyAttachment",
            "uniqueId": "Workflow_putnameinbucket_IamRolePolicyAttachment_7062B349"
          }
        },
        "policy_arn": "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
        "role": "${aws_iam_role.Workflow_putnameinbucket_IamRole_F8FA413B.name}"
      }
    },
    "aws_lambda_function": {
      "Workflow_getnamefrombucket_59CDAA2E": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/get name from bucket/Default",
            "uniqueId": "Workflow_getnamefrombucket_59CDAA2E"
          }
        },
        "architectures": [
          "arm64"
        ],
        "environment": {
          "variables": {
            "BUCKET_NAME_1357ca3a": "${aws_s3_bucket.Bucket.bucket}",
            "NODE_OPTIONS": "--enable-source-maps",
            "WING_FUNCTION_NAME": "get-name-from-bucket-c8b7dd00",
            "WING_TARGET": "tf-aws"
          }
        },
        "function_name": "get-name-from-bucket-c8b7dd00",
        "handler": "index.handler",
        "memory_size": 1024,
        "publish": true,
        "role": "${aws_iam_role.Workflow_getnamefrombucket_IamRole_C3A26695.arn}",
        "runtime": "nodejs20.x",
        "s3_bucket": "${aws_s3_bucket.Code.bucket}",
        "s3_key": "${aws_s3_object.Workflow_getnamefrombucket_S3Object_BBA367F6.key}",
        "timeout": 60,
        "vpc_config": {
          "security_group_ids": [
          ],
          "subnet_ids": [
          ]
        }
      },
      "Workflow_hasname_ACEE9260": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/has name?/Default",
            "uniqueId": "Workflow_hasname_ACEE9260"
          }
        },
        "architectures": [
          "arm64"
        ],
        "environment": {
          "variables": {
            "NODE_OPTIONS": "--enable-source-maps",
            "WING_FUNCTION_NAME": "has-name--c84b2e93",
            "WING_TARGET": "tf-aws"
          }
        },
        "function_name": "has-name--c84b2e93",
        "handler": "index.handler",
        "memory_size": 1024,
        "publish": true,
        "role": "${aws_iam_role.Workflow_hasname_IamRole_CFA5F101.arn}",
        "runtime": "nodejs20.x",
        "s3_bucket": "${aws_s3_bucket.Code.bucket}",
        "s3_key": "${aws_s3_object.Workflow_hasname_S3Object_7E263F33.key}",
        "timeout": 60,
        "vpc_config": {
          "security_group_ids": [
          ],
          "subnet_ids": [
          ]
        }
      },
      "Workflow_putnameinbucket_C2924BDA": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/put name in bucket/Default",
            "uniqueId": "Workflow_putnameinbucket_C2924BDA"
          }
        },
        "architectures": [
          "arm64"
        ],
        "environment": {
          "variables": {
            "BUCKET_NAME_1357ca3a": "${aws_s3_bucket.Bucket.bucket}",
            "NODE_OPTIONS": "--enable-source-maps",
            "WING_FUNCTION_NAME": "put-name-in-bucket-c85c34a8",
            "WING_TARGET": "tf-aws"
          }
        },
        "function_name": "put-name-in-bucket-c85c34a8",
        "handler": "index.handler",
        "memory_size": 1024,
        "publish": true,
        "role": "${aws_iam_role.Workflow_putnameinbucket_IamRole_F8FA413B.arn}",
        "runtime": "nodejs20.x",
        "s3_bucket": "${aws_s3_bucket.Code.bucket}",
        "s3_key": "${aws_s3_object.Workflow_putnameinbucket_S3Object_1540E528.key}",
        "timeout": 60,
        "vpc_config": {
          "security_group_ids": [
          ],
          "subnet_ids": [
          ]
        }
      }
    },
    "aws_s3_bucket": {
      "Bucket": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Bucket/Default",
            "uniqueId": "Bucket"
          }
        },
        "bucket_prefix": "bucket-c88fdc5f-",
        "force_destroy": false
      },
      "Code": {
        "//": {
          "metadata": {
            "path": "root/Default/Code",
            "uniqueId": "Code"
          }
        },
        "bucket_prefix": "code-c84a50b1-"
      }
    },
    "aws_s3_object": {
      "Workflow_getnamefrombucket_S3Object_BBA367F6": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/get name from bucket/S3Object",
            "uniqueId": "Workflow_getnamefrombucket_S3Object_BBA367F6"
          }
        },
        "bucket": "${aws_s3_bucket.Code.bucket}",
        "key": "asset.c8b7dd008b67ebd055097ad9f961b569790c845487.a00136c59be44e317991cfe2fa930d7d.zip",
        "source": "assets/Workflow_getnamefrombucket_Asset_392FEE97/218A4AAF94F3D9B26BF279332D359C24/archive.zip"
      },
      "Workflow_hasname_S3Object_7E263F33": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/has name?/S3Object",
            "uniqueId": "Workflow_hasname_S3Object_7E263F33"
          }
        },
        "bucket": "${aws_s3_bucket.Code.bucket}",
        "key": "asset.c84b2e93516d7a51ee732db0d555026f3cdbb63a86.e7e93a98756cc31c281960dd247faac9.zip",
        "source": "assets/Workflow_hasname_Asset_B1A6530A/2C0A67D8F2B12A82088BE71F633BCAF8/archive.zip"
      },
      "Workflow_putnameinbucket_S3Object_1540E528": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workflow/Workflow/put name in bucket/S3Object",
            "uniqueId": "Workflow_putnameinbucket_S3Object_1540E528"
          }
        },
        "bucket": "${aws_s3_bucket.Code.bucket}",
        "key": "asset.c85c34a85139279d2c3e19e9aaaf8ab4fc1604cc1e.304295062a2d33380fbf0c4d031c1aa2.zip",
        "source": "assets/Workflow_putnameinbucket_Asset_19D5A73C/898832CB5CF5F614021379F4DF9C63FF/archive.zip"
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
        "definition": "{\"StartAt\":\"has name?\",\"States\":{\"has name?\":{\"Type\":\"Task\",\"Resource\":\"arn:aws:states:::lambda:invoke\",\"OutputPath\":\"$.Payload\",\"Parameters\":{\"Payload.$\":\"$\",\"FunctionName\":\"${aws_lambda_function.Workflow_hasname_ACEE9260.function_name}\"},\"Next\":\"has name? (choice)\"},\"put name in bucket\":{\"Type\":\"Task\",\"Resource\":\"arn:aws:states:::lambda:invoke\",\"OutputPath\":\"$.Payload\",\"Parameters\":{\"Payload.$\":\"$\",\"FunctionName\":\"${aws_lambda_function.Workflow_putnameinbucket_C2924BDA.function_name}\"},\"End\":true},\"get name from bucket\":{\"Type\":\"Task\",\"Resource\":\"arn:aws:states:::lambda:invoke\",\"OutputPath\":\"$.Payload\",\"Parameters\":{\"Payload.$\":\"$\",\"FunctionName\":\"${aws_lambda_function.Workflow_getnamefrombucket_59CDAA2E.function_name}\"},\"End\":true},\"has name? (choice)\":{\"Type\":\"Choice\",\"Choices\":[{\"Variable\":\"$.result\",\"BooleanEquals\":true,\"Next\":\"put name in bucket\"}],\"Default\":\"get name from bucket\"}}}",
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
