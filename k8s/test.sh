#!/bin/sh
echo "Compiling..."
wing compile .
echo "Generating docs..."
wing gen-docs
