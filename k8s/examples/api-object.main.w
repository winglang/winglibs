bring ".." as k8s;

new k8s.ApiObject(
  apiVersion: "v1",
  kind: "ConfigMap",
  metadata: {
    name: "your-config",
  },
  spec: {
    data: {
      "key": "value",
    },
  },
);
