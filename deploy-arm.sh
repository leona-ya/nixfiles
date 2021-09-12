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

rsync -r /home/em0lar/dev/nixfiles adonis.net.em0lar.dev:/tmp
ssh -A adonis.net.em0lar.dev "cd /tmp/nixfiles && deploy -s --targets .#${HOSTS} && cd /tmp && rm -rf /tmp/nixfiles"
