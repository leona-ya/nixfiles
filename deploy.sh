#!/usr/bin/env bash

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
      -h|--host)
      HOST="$2"
      shift
      shift
      ;;
      -g|--groups)
      GROUP="$2"
      shift
      shift
      ;;
      *)
      shift
      ;;
  esac
done


if [ -z $GROUP ];
then
    HOSTS=".#$HOST"
    echo "hst"
else
    JQ_ARGS=""
    HOSTS=.#$(cat hosts/groups.json | jq -r ".$GROUP.hosts | join(\" .#\")")
    echo "gr"
fi

echo $HOSTS

rsync -r /home/em0lar/dev/nixfiles hack.net.em0lar.dev:/tmp -e "ssh -p 61337"
ssh -A -p 61337 hack.net.em0lar.dev "cd /tmp/nixfiles && deploy -s --targets $HOSTS && cd /tmp && rm -rf /tmp/nixfiles"
