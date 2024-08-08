bring "../" as containers;
bring cloud;
bring http;
bring expect;

let producer = new containers.Workload(
  name: "producer",
  image: "{@dirname}/microservices_producer",
  port: 4000,
) as "producer";

let consumer = new containers.Workload(
  name: "consumer",
  image: "{@dirname}/microservices_consumer",
  port: 3000,
  public: true,
  env: {
    PRODUCER_URL: producer.internalUrl,
  }
) as "consumer";

// TODO: failing on github for now:
// test "send request" {
//   if let url = consumer.publicUrl {
//     log("get {url}...");
//     if let body = http.get(url).body {
//       expect.equal(body, Json.stringify({ producer_result: { result: 12 } }));
//     } else {
//       assert(false);
//     }
//   }
// }
