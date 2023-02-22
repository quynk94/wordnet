#!/bin/bash

top=$(dirname $0)
set -e

$top/stop.sh
$top/start.sh
