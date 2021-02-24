#!/usr/bin/env bash

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
      -h|--host)
      HOST="$2"
      shift
      shift
      ;;
      *)
      shift
      ;;
  esac
done

rsync -r /home/em0lar/dev/nixfiles aido.int.sig.de.em0lar.dev:/tmp
ssh -A aido.int.sig.de.em0lar.dev "cd /tmp/nixfiles && nix run github:serokell/deploy-rs .#${HOST} && cd /tmp && rm -rf /tmp/nixfiles"
