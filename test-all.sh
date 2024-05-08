#!/bin/bash
set -euo pipefail

WING=${WING:-wing}

for i in $(ls -F); do
  if [ -f "$i/package.json" ]; then
    echo "-----------------------------------------------------------------------------"
    echo $i
    echo "-----------------------------------------------------------------------------"
    (
      cd $i
      npm i
      if [ -x test.sh ]; then
        ./test.sh
      else
        $WING test
      fi
    )
  fi
done
