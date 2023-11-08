#!/bin/sh
if [ -z "$1" ]; then
  echo "Usage: mklib.sh <libname>"
  exit 1
fi

mkdir $1
cat > $1/package.json <<HERE
{
  "name": "@winglibs/$1",
  "version": "0.0.1",
  "repository": {
    "type": "git",
    "url": "https://github.com/winglang/winglibs.git",
    "directory": "$1"
  },
  "license": "MIT"
}
HERE

cat > $1/lib.w <<HERE
pub class Adder {
  pub inflight add(x: num, y: num): num {
    return x + y;
  }
}
HERE

cat > $1/lib.test.w <<HERE
bring expect;
bring "./lib.w" as l;

let adder = new l.Adder();

test "add() adds two numbers" {
  expect.equal(adder.add(1, 2), 3);
}
HERE


wing compile generate-workflows.main.w
rm -fr target/

cd $1
wing test **/*.test.w
