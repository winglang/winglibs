# simtools

This library is a set of tools that are supposed to make the user of the simulator a happier developer. 

For the time being, it contains only one function, `addMacro()`.

## Using `addMacro`

This function adds a Macro into the target resource's interaction pane in Wing Console.
Every macro that is added is seen as a button on the right side panel.

The following code:
```wing
bring cloud;
bring simtools;

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
```

Will create two buttons on the Bucket resource on the right side panel:
* Clean
* Populate

![image](https://github.com/winglang/winglibs/assets/1727147/909be141-f0f3-4c7c-aa1b-9c7ba5aae560)



## Prerequisites

* [winglang](https://winglang.io).

## Installation

```sh
npm i @winglibs/simtools
```


## License

This library is licensed under the [MIT License](./LICENSE).
