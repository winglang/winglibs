#!/bin/sh

wing compile -t ./lib/index.js examples/nodejs.main.w
wing compile -t ./lib/index.js examples/ubuntu.main.w
wing compile -t ./lib/index.js root.test.w
