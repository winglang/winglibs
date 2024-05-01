#!/bin/sh
cd examples
wing compile -t ../lib/index.js nodejs.main.w
wing compile -t ../lib/index.js ubuntu.main.w
