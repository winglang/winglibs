#!/bin/sh
if [ -n "$CI" ]; then
  snapshot_mode="assert"
else
  snapshot_mode="update"
fi

DEBUG=1 wing test
WING_CONTAINERS_PROVIDER="eks" wing test -t tf-aws -s $snapshot_mode test/containers.test.w
WING_CONTAINERS_PROVIDER="eks" wing test -t tf-aws -s $snapshot_mode test/containers-with-readiness.test.w
