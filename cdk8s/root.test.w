// Check that the app has a valid root
// (regression test for https://github.com/winglang/wing/issues/6806)

let root = nodeof(this).root;
log("root: " + nodeof(root).path);
