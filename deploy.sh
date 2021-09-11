#!/usr/bin/env bash

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
      -h|--hosts)
      HOSTS="$2"
      shift
      shift
      ;;
      *)
      shift
      ;;
  esac
done

rsync -r /home/em0lar/dev/nixfiles 10.151.4.6:/tmp -e "ssh -p 61337"
ssh -A -p 61337 10.151.4.6 "cd /tmp/nixfiles && deploy -s --targets .#${HOSTS} && cd /tmp && rm -rf /tmp/nixfiles"
