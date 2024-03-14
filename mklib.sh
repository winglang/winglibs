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

cat > $1/.gitignore <<HERE
target/
node_modules/
HERE

cat > $1/README.md <<HERE
# $1

## Prerequisites

* [winglang](https://winglang.io).

## Installation

\`\`\`sh
npm i @winglibs/$1
\`\`\`

## Usage

\`\`\`js
bring $1;

let adder = new $1.Adder();
\`\`\`

## License

This library is licensed under the [MIT License](./LICENSE).
HERE

cp ./LICENSE $1/

wing compile generate-workflows.main.w
rm -fr target/

cd $1
wing test *.test.w
