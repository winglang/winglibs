bring cloud;
bring "./lib.w" as simtools;

let bucket = new cloud.Bucket();

simtools.addMacro(bucket, "Clean", inflight () => {
  for i in bucket.list() {
    bucket.delete(i);
  }
});

simtools.addMacro(bucket, "Populate",  inflight () => {
 for i in 1..10 {
  bucket.put("{i}.txt", "This is {i}");
 }
});
