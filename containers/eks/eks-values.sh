#!/bin/sh
if [ -z "$1" ]; then
  echo "Usage: $0 <cluster-name>"
  exit 1
fi

export cluster_name=$1

cat << EOF
eks.cluster_name: $cluster_name
eks.endpoint: $(aws eks describe-cluster --name $cluster_name --query "cluster.endpoint")
eks.certificate: $(aws eks describe-cluster --name $cluster_name --query "cluster.certificateAuthority.data")
EOF
