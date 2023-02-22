#!/bin/bash

top=$(dirname $0)
set -e

$top/docker-compose.development.sh -p wordnetdevelopment up -d
docker attach wordnet_rails_development
