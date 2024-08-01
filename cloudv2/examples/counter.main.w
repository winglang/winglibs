bring cloud;
bring "../" as cloudv2;
bring expect;

let bucket = new cloud.Bucket();
let counter = new cloudv2.Counter();

let fn = new cloud.Function(inflight () => {
  bucket.put("file-{counter.inc()}.txt", "Hello, World!");
});

test "add files" {
  fn.invoke();
  fn.invoke();
  fn.invoke();
  expect.equal(bucket.list(), ["file-0.txt", "file-1.txt", "file-2.txt"]);
}
