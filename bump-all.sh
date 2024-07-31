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

# Find all package.json files in subdirectories
for package_file in */package.json; do
    # Check if the package.json file exists
    if [[ -f "$package_file" ]]; then
        # Extract the current version
        current_version=$(jq -r '.version' "$package_file")
        
        # Increment the patch version
        new_version=$(increment_patch_version "$current_version")
        
        # Update the version in package.json
        jq --arg new_version "$new_version" '.version = $new_version' "$package_file" > temp.json && mv temp.json "$package_file"
        
        echo "Updated $package_file from $current_version to $new_version"
    else
        echo "No package.json found in $package_file"
    fi
done
