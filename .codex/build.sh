#!/usr/bin/env bash

set -euo pipefail

GITHUB_WORKSPACE=/workspace/ghc

apt update

apt install -y \
  automake \
  libgmp-dev \
  zstd

curl -f -L https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_CABAL_VERSION=latest BOOTSTRAP_HASKELL_GHC_VERSION=9.12.2 BOOTSTRAP_HASKELL_INSTALL_NO_STACK=1 BOOTSTRAP_HASKELL_NONINTERACTIVE=1 bash

. ~/.ghcup/env

sed -i -e 's/-- executable-dynamic: False/executable-dynamic: True/' -e 's/-- optimization: True/optimization: 2/' -e 's/-- semaphore: False/semaphore: True/' ~/.cabal/config

cabal install --ignore-project alex happy

./boot

./configure

hadrian/build --version

echo :q | HADRIAN_ARGS=-j ./hadrian/ghci-multi -j

git -C $GITHUB_WORKSPACE ls-files -oi --exclude-standard -z \
  | sed -z "s|^|$GITHUB_WORKSPACE/|" >> /tmp/listing

git -C $GITHUB_WORKSPACE submodule foreach --quiet --recursive '
  git ls-files -oi --exclude-standard -z \
    | sed -z "s|^|$toplevel/$path/|" >> /tmp/listing
'

printf "%s\0" /root/.ghcup /root/.cabal >> /tmp/listing

rm -rf \
  ~/.cabal/logs \
  ~/.cabal/packages \
  ~/.ghcup/cache \
  ~/.ghcup/ghc/9.12.2/share/doc \
  ~/.ghcup/ghc/9.12.2/share/man \
  ~/.ghcup/logs

find ~/.ghcup/ghc \( -name '*.p_hi' -o -name '*.p_dyn_hi' -o -name '*_p.a' -o -name '*_p.so' -o -name '*_p-ghc9.12.2.so' \) -type f -delete

tar --create \
    --null --files-from=/tmp/listing \
    --absolute-names \
    --sort=name --owner=0 --group=0 --numeric-owner \
    --file=/workspace/ghc/codex-cache.tar

zstd -T0 --ultra -22 /workspace/ghc/codex-cache.tar
