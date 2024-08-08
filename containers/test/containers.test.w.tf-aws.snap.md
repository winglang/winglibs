# `containers.test.w.tf-aws.snap.md`

## main.tf.json

```json
{
  "//": {
    "metadata": {
      "backend": "local",
      "stackName": "root",
      "version": "0.20.7"
    },
    "outputs": {
      "root": {
        "Default": {
          "Default": {
            "WingEksCluster": {
              "eks.certificate": "WingEksCluster_ekscertificate_183C7367",
              "eks.cluster_name": "WingEksCluster_ekscluster_name_E1D79024",
              "eks.endpoint": "WingEksCluster_eksendpoint_FD8710BA"
            }
          }
        }
      }
    }
  },
  "data": {
    "aws_availability_zones": {
      "WingEksCluster_Vpc_DataAwsAvailabilityZones_088D4D6B": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/WingEksCluster/Vpc/DataAwsAvailabilityZones",
            "uniqueId": "WingEksCluster_Vpc_DataAwsAvailabilityZones_088D4D6B"
          }
        },
        "filter": {
          "name": "opt-in-status",
          "values": [
            "opt-in-not-required"
          ]
        }
      }
    },
    "aws_caller_identity": {
      "WingAwsUtil_DataAwsCallerIdentity_E989AAD9": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/WingAwsUtil/DataAwsCallerIdentity",
            "uniqueId": "WingAwsUtil_DataAwsCallerIdentity_E989AAD9"
          }
        }
      }
    },
    "aws_region": {
      "WingAwsUtil_DataAwsRegion_EEBA70AA": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/WingAwsUtil/DataAwsRegion",
            "uniqueId": "WingAwsUtil_DataAwsRegion_EEBA70AA"
          }
        }
      }
    },
    "kubernetes_ingress_v1": {
      "Workload_http-echo_DataKubernetesIngressV1_A36C9067": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workload/http-echo/DataKubernetesIngressV1",
            "uniqueId": "Workload_http-echo_DataKubernetesIngressV1_A36C9067"
          }
        },
        "depends_on": [
          "helm_release.Workload_http-echo_Release_73477725"
        ],
        "metadata": {
          "name": "http-echo"
        },
        "provider": "kubernetes"
      }
    }
  },
  "module": {
    "WingEksCluster_Vpc_TerraformHclModule_708526D4": {
      "//": {
        "metadata": {
          "path": "root/Default/Default/WingEksCluster/Vpc/TerraformHclModule",
          "uniqueId": "WingEksCluster_Vpc_TerraformHclModule_708526D4"
        }
      },
      "azs": "${slice(data.aws_availability_zones.WingEksCluster_Vpc_DataAwsAvailabilityZones_088D4D6B.names, 0, 3)}",
      "cidr": "10.0.0.0/16",
      "enable_dns_hostnames": true,
      "enable_nat_gateway": true,
      "private_subnet_tags": {
        "kubernetes.io/cluster/wing-eks-c8281f": "shared",
        "kubernetes.io/role/internal-elb": "1"
      },
      "private_subnets": [
        "10.0.1.0/24",
        "10.0.2.0/24",
        "10.0.3.0/24"
      ],
      "public_subnet_tags": {
        "kubernetes.io/cluster/wing-eks-c8281f": "shared",
        "kubernetes.io/role/elb": "1"
      },
      "public_subnets": [
        "10.0.4.0/24",
        "10.0.5.0/24",
        "10.0.6.0/24"
      ],
      "single_nat_gateway": true,
      "source": "terraform-aws-modules/vpc/aws",
      "version": "4.0.2"
    },
    "WingEksCluster_eks_B53CDB45": {
      "//": {
        "metadata": {
          "path": "root/Default/Default/WingEksCluster/eks",
          "uniqueId": "WingEksCluster_eks_B53CDB45"
        }
      },
      "cluster_addons": {
        "coredns": {
          "configuration_values": "${jsonencode({\"computeType\" = \"Fargate\"})}"
        },
        "kube-proxy": {
        },
        "vpc-cni": {
        }
      },
      "cluster_endpoint_public_access": true,
      "cluster_name": "wing-eks-c8281f",
      "cluster_version": "1.27",
      "create_cluster_security_group": false,
      "create_node_security_group": false,
      "fargate_profiles": {
        "default": {
          "name": "default",
          "selectors": [
            {
              "namespace": "kube-system"
            },
            {
              "namespace": "default"
            }
          ]
        }
      },
      "source": "terraform-aws-modules/eks/aws",
      "subnet_ids": "${module.WingEksCluster_Vpc_TerraformHclModule_708526D4.private_subnets}",
      "version": "19.17.1",
      "vpc_id": "${module.WingEksCluster_Vpc_TerraformHclModule_708526D4.vpc_id}"
    },
    "WingEksCluster_lb_role_271BFF6C": {
      "//": {
        "metadata": {
          "path": "root/Default/Default/WingEksCluster/lb_role",
          "uniqueId": "WingEksCluster_lb_role_271BFF6C"
        }
      },
      "attach_load_balancer_controller_policy": true,
      "oidc_providers": {
        "main": {
          "namespace_service_accounts": [
            "kube-system:aws-load-balancer-controller"
          ],
          "provider_arn": "${module.WingEksCluster_eks_B53CDB45.oidc_provider_arn}"
        }
      },
      "role_name": "eks-lb-role-c8c8413959d4dc713edd195c49a192ea57f59d59fd",
      "source": "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
    }
  },
  "output": {
    "WingEksCluster_ekscertificate_183C7367": {
      "description": "eks.certificate",
      "value": "${module.WingEksCluster_eks_B53CDB45.cluster_certificate_authority_data}"
    },
    "WingEksCluster_ekscluster_name_E1D79024": {
      "description": "eks.cluster_name",
      "value": "wing-eks-c8281f"
    },
    "WingEksCluster_eksendpoint_FD8710BA": {
      "description": "eks.endpoint",
      "value": "${module.WingEksCluster_eks_B53CDB45.cluster_endpoint}"
    }
  },
  "provider": {
    "aws": [
      {
      }
    ],
    "helm": [
      {
        "kubernetes": {
          "cluster_ca_certificate": "${base64decode(module.WingEksCluster_eks_B53CDB45.cluster_certificate_authority_data)}",
          "exec": {
            "api_version": "client.authentication.k8s.io/v1beta1",
            "args": [
              "eks",
              "get-token",
              "--cluster-name",
              "wing-eks-c8281f"
            ],
            "command": "aws"
          },
          "host": "${module.WingEksCluster_eks_B53CDB45.cluster_endpoint}"
        }
      }
    ],
    "kubernetes": [
      {
        "cluster_ca_certificate": "${base64decode(module.WingEksCluster_eks_B53CDB45.cluster_certificate_authority_data)}",
        "exec": {
          "api_version": "client.authentication.k8s.io/v1beta1",
          "args": [
            "eks",
            "get-token",
            "--cluster-name",
            "wing-eks-c8281f"
          ],
          "command": "aws"
        },
        "host": "${module.WingEksCluster_eks_B53CDB45.cluster_endpoint}"
      }
    ]
  },
  "resource": {
    "helm_release": {
      "WingEksCluster_Release_AE9D9364": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/WingEksCluster/Release",
            "uniqueId": "WingEksCluster_Release_AE9D9364"
          }
        },
        "chart": "aws-load-balancer-controller",
        "depends_on": [
          "kubernetes_service_account.WingEksCluster_ServiceAccount_580F8592"
        ],
        "name": "aws-load-balancer-controller",
        "namespace": "kube-system",
        "provider": "helm",
        "repository": "https://aws.github.io/eks-charts",
        "set": [
          {
            "name": "region",
            "value": "${data.aws_region.WingAwsUtil_DataAwsRegion_EEBA70AA.name}"
          },
          {
            "name": "vpcId",
            "value": "${module.WingEksCluster_Vpc_TerraformHclModule_708526D4.vpc_id}"
          },
          {
            "name": "serviceAccount.create",
            "value": "false"
          },
          {
            "name": "serviceAccount.name",
            "value": "aws-load-balancer-controller"
          },
          {
            "name": "clusterName",
            "value": "wing-eks-c8281f"
          }
        ]
      },
      "Workload_http-echo_Release_73477725": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/Workload/http-echo/Release",
            "uniqueId": "Workload_http-echo_Release_73477725"
          }
        },
        "chart": ".wing/helm/http-echo-63344863709bcf4e44f7b887311641a4",
        "depends_on": [
        ],
        "name": "http-echo",
        "provider": "helm",
        "values": [
          "image: hashicorp/http-echo"
        ]
      }
    },
    "kubernetes_service_account": {
      "WingEksCluster_ServiceAccount_580F8592": {
        "//": {
          "metadata": {
            "path": "root/Default/Default/WingEksCluster/ServiceAccount",
            "uniqueId": "WingEksCluster_ServiceAccount_580F8592"
          }
        },
        "metadata": {
          "annotations": {
            "eks.amazonaws.com/role-arn": "${module.WingEksCluster_lb_role_271BFF6C.iam_role_arn}",
            "eks.amazonaws.com/sts-regional-endpoints": "true"
          },
          "labels": {
            "app.kubernetes.io/component": "controller",
            "app.kubernetes.io/name": "aws-load-balancer-controller"
          },
          "name": "aws-load-balancer-controller",
          "namespace": "kube-system"
        },
        "provider": "kubernetes"
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
        "version": "5.56.1"
      },
      "helm": {
        "source": "helm",
        "version": "2.12.1"
      },
      "kubernetes": {
        "source": "kubernetes",
        "version": "2.27.0"
      }
    }
  }
}
```
