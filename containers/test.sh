#!/bin/sh
if [ -n "$CI" ]; then
  snapshot_mode="assert"
else
  snapshot_mode="update"
fi

DEBUG=1 wing test
wing test -t tf-aws -s $snapshot_mode containers.test.w
wing test -t tf-aws -s $snapshot_mode containers-with-readiness.test.w
