#!/bin/bash

top=$(dirname $0)
set -e

$top/docker-compose.development.sh -p wordnetdevelopment stop
