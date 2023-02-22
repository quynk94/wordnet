#!/bin/bash

top=$(dirname $0)
if ! [[ $(pwd) =~ /wordnet/srv$ ]]; then
  echo "ERROR: Wrong directory. Please change directory to wordnet/srv and try again"
  exit 1
fi

set -e

POSITIONAL=()

while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    --ssh-key)
    SSH_KEY_PATH="$2"
    shift
    shift
    ;;
    *)
    POSITIONAL+=("$1")
    shift
    ;;
  esac
done

set -- "${POSITIONAL[@]}"

if ! [[ -n $SSH_KEY_PATH ]]
then
  echo "ERROR: No SSH key provided. Please specify the SSH key to connect to Github... Eg: --ssh-key ~/.ssh/id_rsa"
  exit 1
fi

if ! [[ -f $SSH_KEY_PATH ]]
then
  echo "ERROR: SSH key not found. Please check the path"
  exit 1
fi

echo "Using $SSH_KEY_PATH as the SSH key"

SSH_KEY_NAME=`basename $SSH_KEY_PATH`
SSH_KEY_DIR=`dirname $SSH_KEY_PATH`

docker-compose -f docker-compose.yml -f docker-compose.development.yml -p wordnetdevelopment build

docker volume create --name wordnet_git_ssh_key --driver local

KNOWN_HOSTS=`ssh-keyscan github.com`

docker run --rm -v $SSH_KEY_DIR:/source -v wordnet_git_ssh_key:/dest -w /source busybox sh -c "
  cp $SSH_KEY_NAME /dest/id_rsa &&
  chmod 700 /dest &&
  chmod 600 /dest/id_rsa &&
  echo '$KNOWN_HOSTS' > /dest/known_hosts
"

docker network inspect global_development > /dev/null 2>&1 || docker network create --driver=bridge --subnet=172.16.100.0/24 global_development

$top/docker-compose.development.sh \
    -p wordnetdevelopment run --rm --entrypoint=/bin/bash \
    rails -c \
    "eval \`ssh-agent\` && ssh-add ~/.ssh/id_rsa && \
    bundle install && \
    $top/wait_for_it.sh mysql:3307 -- \
    bundle exec rake db:drop db:create db:migrate"

$top/docker-compose.development.sh \
    -p wordnetdevelopment run --rm --entrypoint=/bin/bash \
    rails -c "$top/wait_for_it.sh mysql:3307 -- bundle exec rake db:seed"
