#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils gnupg
cd $(dirname $0)/..
lib/pass.sh init $(cat secrets/.gpg-id)
