#!/bin/bash
set -euo pipefail

WING=${WING:-wing}

# Read the skipped packages from the JSON file
skipped_packages=$(jq -r '.["skipped-packages"][].name' SKIPPED_LIBRARIES.json)

for package_file in */package.json; do
  # Check if the package.json file exists
  if [[ ! -f "$package_file" ]]; then
      continue
  fi

  package_name="${package_file%/package.json}"

  echo "-----------------------------------------------------------------------------"
  echo $package_name
  echo "-----------------------------------------------------------------------------"

  # Check if the package should be skipped
  if echo "$skipped_packages" | grep -q "^$package_name$"; then
    echo "Skipping $package_name"
    continue
  fi

  (
    cd $package_name
    npm i
    if [ -x test.sh ]; then
      ./test.sh
    else
      $WING test
    fi
  )
done
