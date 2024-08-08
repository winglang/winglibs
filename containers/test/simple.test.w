bring cloud;
bring http;
bring "../" as containers;
bring expect;

let app = new containers.Workload(
  name: "http-echo",
  image: "hashicorp/http-echo",
  port: 5678,
  public: true,
  replicas: 2,
  args: ["-text=bang_bang"],
);

new cloud.Function(inflight () => {
  log(app.publicUrl ?? "no public url yet");
}) as "get public url";

test "http get" {
  if let url = app.publicUrl {
    let response = http.get(url);
    expect.equal("bang_bang\n", response.body);
  }
}
