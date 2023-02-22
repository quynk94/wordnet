#!/bin/bash

top=$(dirname $0)
set -e

$top/docker-compose.development.sh \
    -p wordnetdevelopment \
    run --rm --entrypoint=/bin/bash rails -c "$@"
