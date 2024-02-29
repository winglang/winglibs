#!/bin/sh

for dir in */ ; do
    if [ -f "$dir/package.json" ]; then
        cd "$dir"        
        if grep -q "\"winglang\"" package.json; then
            echo "Updating winglang in '$dir'..."
            npm update winglang
            npm version patch
        else
            echo "winglang not found in '$dir'.\n"
        fi        
        cd -
    fi
done
