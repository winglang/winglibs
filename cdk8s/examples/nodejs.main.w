bring "cdk8s-plus-27" as k8s;
bring fs;

// lets create a volume that contains our app.
let appData = new k8s.ConfigMap();
appData.addDirectory(fs.join(@dirname, "./nodejs-app"));

let appVolume = k8s.Volume.fromConfigMap(this, "App", appData);

// lets create a deployment to run a few instances of a pod
let deployment = new k8s.Deployment(
  replicas: 3,
);

// now we create a container that runs our app
let appPath = "/var/lib/app";
let port = 80;
let container = deployment.addContainer({
  image: "node:14.4.0-alpine3.12",
  command: ["node", "index.js", "{port}"],
  port: port,
  workingDir: appPath,
});

// make the app accessible to the container
container.mount(appPath, appVolume);

// finally, we expose the deployment as a load balancer service and make it run
deployment.exposeViaService(serviceType: k8s.ServiceType.LOAD_BALANCER);
