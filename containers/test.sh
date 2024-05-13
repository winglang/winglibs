#!/bin/sh
DEBUG=1 wing test
wing test -t tf-aws -s assert containers.test.w
