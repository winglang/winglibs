bring "../" as containers;
bring http;
bring expect;

let app = new containers.Workload(
  name: "my-app",
  image: "{@dirname}/my_app",
  port: 3000,
  public: true,
);

test "can access container" {
  let response = http.get("{app.publicUrl!}");
  expect.equal(response.body, "Hello, Wingnuts!");
}