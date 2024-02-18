#!/bin/sh
set -euo pipefail

for i in $(ls -F); do
  if [ -f "$i/package.json" ]; then
    echo "-----------------------------------------------------------------------------"
    echo $i
    echo "-----------------------------------------------------------------------------"
    (
      cd $i
      npm i
      wing test
    )
  fi
done
