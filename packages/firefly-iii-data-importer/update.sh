#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix curl jq nix-update

# check if composer2nix is installed
if ! command -v composer2nix &> /dev/null; then
  echo "Please install composer2nix (https://github.com/svanderburg/composer2nix) to run this script."
  exit 1
fi

#CURRENT_VERSION=$(nix eval --raw '(with import ../../../.. {}; firefly-iii.version)')
CURRENT_VERSION=0.7.0
TARGET_VERSION=$(curl https://api.github.com/repos/firefly-iii/data-importer/releases/latest | jq -r ".tag_name")
FIREFLYIII=https://github.com/firefly-iii/data-importer/raw/$TARGET_VERSION
SHA256=$(nix-prefetch-url --unpack "https://github.com/firefly-iii/data-importer/archive/$TARGET_VERSION/data-importer.tar.gz")

if [[ "$CURRENT_VERSION" == "$TARGET_VERSION" ]]; then
  echo "firefly-iii is up-to-date: ${CURRENT_VERSION}"
  exit 0
fi

curl -LO "$FIREFLYIII/composer.json"
curl -LO "$FIREFLYIII/composer.lock"

composer2nix --name "firefly-iii" \
  --composition=composition.nix \
  --no-dev
rm composer.json composer.lock

# change version number
sed -e "s/version =.*;/version = \"$TARGET_VERSION\";/g" \
    -e "s/sha256 =.*;/sha256 = \"$SHA256\";/g" \
    -i ./default.nix

# fix composer-env.nix
sed -e "s/stdenv\.lib/lib/g" \
    -e '3s/stdenv, writeTextFile/stdenv, lib, writeTextFile/' \
    -i ./composer-env.nix

# fix composition.nix
sed -e '7s/stdenv writeTextFile/stdenv lib writeTextFile/' \
    -i composition.nix

# fix missing newline
echo "" >> composition.nix
echo "" >> php-packages.nix

#cd ../../../..
#nix-build -A firefly-iii

exit $?
