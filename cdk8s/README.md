# cdk8s support for Wing

This library is a custom Wing platform that can be used to synthesize Kubernetes YAML manifests
through [cdk8s](https://cdk8s.io) constructs.

## Prerequisites

* [Wing CLI](https://winglang.io).

## Installation

Install the Wing CLI:

```sh
npm i -g winglang
```

Create a new project and install this library:

```sh
mkdir wing-loves-cdk8s
cd wing-loves-cdk8s
npm i @winglibs/cdk8s
```

If you wish to use [cdk8s-plus](https://cdk8s.io/docs/latest/plus/), you'll also
need to install it (choose the relevant K8S version):

```sh
npm i cdk8s-plus-27
```

## Usage

Let's define a Deployment resource with 3 replicas of the `ubuntu` public Docker image:

```js
// ubuntu.main.w
bring "cdk8s-plus-27" as k8s;

let deployment = new k8s.Deployment(replicas: 3);
deployment.addContainer(image: "ubuntu");
```

Now, compile it to YAML:

```sh
$ wing compile -t @winglibs/cdk8s ubuntu.main.w
target/ubuntu.main.cdk8s
```

The output is a valid K8S YAML is in `target/ubuntu.main.cdk8s`:

```sh
$ ls target/ubuntu.main.cdk8s
chart-c86185a7.k8s.yaml
```

Here's a more interesting example:

```js
bring "cdk8s-plus-27" as k8s;

// lets create a volume that contains our app.
let appData = new k8s.ConfigMap();
appData.addDirectory("./nodejs-app");

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
```

## Roadmap

* [ ] Support generating Wing bindings from K8S API specifications and CRDs ([`cdk8s
  import`](https://cdk8s.io/docs/latest/cli/import/)).

## Maintainers

* [Elad Ben-Israel](@eladb)

## License

This library is licensed under the [MIT License](./LICENSE).
