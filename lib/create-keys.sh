#!/usr/bin/env bash
set -euo pipefail

cd $(dirname $0)/..

for i in $(cat lib/hosts)
do
    hostname=$(ssh $i "hostname")
    echo $hostname
    mkdir -p secrets/$hostname
    ssh $i "sudo rm -rf /root/.gnupg"
    cat lib/keygen | sed "s/NAME/${hostname}/" | ssh -o RequestTTY=yes $i "nix-shell -p gnupg --run 'sudo gpg --generate-key --pinentry-mode loopback --batch /dev/stdin'"
    cp secrets/.gpg-id secrets/$hostname/.gpg-id
    ssh $i "nix-shell -p gnupg --run \"sudo -u root gpg --fingerprint --with-colons | grep '^fpr' | head -n1 | cut -d: -f10\"" >> secrets/$hostname/.gpg-id
    ssh $i "nix-shell -p gnupg --run 'sudo -u root gpg --export --armor'" > secrets/.public-keys/$hostname
    lib/pass.sh init -p $hostname $(cat secrets/$hostname/.gpg-id);
done
