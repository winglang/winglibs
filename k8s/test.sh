#!/bin/sh
echo "Compiling..."
wing compile .
echo "Generating docs..."
DEBUG="*" wing gen-docs
