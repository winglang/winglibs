bring "../" as containers;
bring expect;
bring http;

let message = "hello, wing change!!";

let hello = new containers.Workload(
  name: "hello",
  image: "paulbouwer/hello-kubernetes:1",
  port: 8080,
  readiness: "/",
  replicas: 2,
  env: {
    "MESSAGE" => message,
  },
  public: true,
) as "hello";


let httpGet = inflight (url: str?): str => {
  if let url = url {
    return http.get(url).body;
  }

  throw "no body";
};

test "access public url" {
  let helloBody = httpGet(hello.publicUrl);
  log(helloBody);
  assert(helloBody.contains(message));
}
