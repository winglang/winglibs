// Check that the app has a valid root
// (regression test for https://github.com/winglang/wing/issues/6806)
bring expect;

let root = nodeof(this).root;
expect.equal(nodeof(root).path, "Chart/App/Default");
