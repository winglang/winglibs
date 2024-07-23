bring "cdk8s-plus-27" as k8s;

let deployment = new k8s.Deployment(replicas: 3);
deployment.addContainer(image: "ubuntu");
