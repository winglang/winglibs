#!/bin/bash
set -euo pipefail

WING=${WING:-wing}

# Read the skipped packages from the JSON file
skipped_packages=$(jq -r '.["skipped-packages"][].name' SKIPPED_LIBRARIES.json)

# Loop through all packages
for package in */; do
  package_name="${package%/}"

  if [ ! -f "$package_name/package.json" ]; then
    continue
  fi

  echo "-----------------------------------------------------------------------------"
  echo $package_name
  echo "-----------------------------------------------------------------------------"

  # Check if the package should be skipped
  if echo "$skipped_packages" | grep -q "^$package_name$"; then
    echo "Skipping $package_name"
    continue
  fi

  (
    cd $package
    npm i
    $WING gen-docs
  )
done
