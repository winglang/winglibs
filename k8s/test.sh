#!/bin/sh
t() {
  out=$(wing compile -t ./lib/index.js $1)

  cat $out/*.yaml > $1.actual.snap

  if [ -f "$1.snap" ]; then
    diff $1.snap $1.actual.snap
    if [ $? -eq 0 ]; then
      echo "$1: passed"
    else
      echo "$1: failed, updating snapshot"
      cp $1.actual.snap $1.snap
      rm $1.actual.snap
      exit 1
    fi
  else
    cp $1.actual.snap $1.snap
  fi

  rm $1.actual.snap
}

t examples/nodejs.main.w

WING_K8S_LABELS='{"app":"bang-bang", "fang": "fang"}' t examples/api-object.main.w
WING_K8S_NAMESPACE=flanging
t examples/ubuntu.main.w

echo "compiling all test files..."
wing compile -t ./lib/index.js *.test.w
