#!/bin/sh
echo "Compiling..."
wing compile .
echo "Generating docs..."
timeout 5s DEBUG="*" wing gen-docs

if [ $? -eq 124 ]; then
    echo "Command timed out after 5 seconds"
    exit 1
fi
