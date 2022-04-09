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

rsync -r /home/leona/dev/nixfiles adonis.net.leona.is:/tmp
ssh -A adonis.net.leona.is "cd /tmp/nixfiles && deploy -s --targets .#${HOSTS} && cd /tmp && rm -rf /tmp/nixfiles"
