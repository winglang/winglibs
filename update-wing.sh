#!/bin/sh

for dir in */ ; do
    if [ -f "$dir/package.json" ]; then
        cd "$dir"        
        if grep -q "\"winglang\"" package.json; then
            echo "Updating winglang in '$dir' winglib..."
            npm update winglang
        else
            echo "winglang not found in '$dir' winglib."
        fi        
        cd ..
    fi
done
