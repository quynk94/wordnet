#!/bin/bash

if ! [[ $(pwd) =~ /wordnet/srv$ ]]; then
  echo "\
ERROR: Wrong directory. Please change directory to wordnet/srv and try again"
  exit 1
fi

args='-f docker-compose.yml -f docker-compose.development.yml'
exec docker-compose $args "$@"
