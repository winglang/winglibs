#!/bin/bash

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Please install jq to run this script."
    exit 1
fi

# Function to increment the patch version
increment_patch_version() {
    local version="$1"
    local IFS=.
    read -a version_parts <<< "$version"
    ((version_parts[2]++))
    echo "${version_parts[0]}.${version_parts[1]}.${version_parts[2]}"
}

# Read the skipped packages from the JSON file
skipped_packages=$(jq -r '.["skipped-packages"][].name' SKIPPED_LIBRARIES.json)

# Find all package.json files in subdirectories
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

    # Extract the current version
    current_version=$(jq -r '.version' "$package_file")
    
    # Increment the patch version
    new_version=$(increment_patch_version "$current_version")
    
    # Update the version in package.json
    jq --arg new_version "$new_version" '.version = $new_version' "$package_file" > temp.json && mv temp.json "$package_file"

    # Run npm install to update package-lock.json
    (
        cd "$package_name"
        npm install
    )

    echo "Updated $package_name from $current_version to $new_version"
done
