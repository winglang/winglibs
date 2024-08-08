bring "../" as containers;
bring expect;
bring http;
bring sim;

let echo = new containers.Workload(
  name: "http-echo",
  image: "hashicorp/http-echo",
  port: 5678,
  public: true,
  replicas: 2,
  args: ["-text=hello1234"],
);

// test "access public url" {
//   let echoBody = http.get(echo.publicUrl!).body;
//   assert(echoBody.contains("hello1234"));
// }
