#!/bin/bash
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

script/docker/wait_for_it.sh mysql:3307 redis:6379 \
  && exec bundle exec "$@"
