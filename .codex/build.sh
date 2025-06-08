#!/usr/bin/env bash

set -euo pipefail

GITHUB_WORKSPACE=/workspace/ghc

apt update

apt install -y \
  automake \
  libgmp-dev \
  zstd

curl -f -L https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_MINIMAL=1 BOOTSTRAP_HASKELL_NONINTERACTIVE=1 bash

. ~/.ghcup/env

ghcup config add-release-channel vanilla

sed -i \
  -e 's/def-ghc-conf-options: null/def-ghc-conf-options: ["--enable-ld-override"]/' \
  -e '/GHCupURL/d' \
  ~/.ghcup/config.yaml

ghcup install cabal latest --set

cabal user-config init

sed -i -e 's/-- executable-dynamic: False/executable-dynamic: True/' -e 's/-- library-vanilla: True/library-vanilla: False/' -e 's/-- minimize-conflict-set: False/minimize-conflict-set: True/' -e 's/-- optimization: True/optimization: 2/' -e 's/-- semaphore: False/semaphore: True/' ~/.config/cabal/config

ghcup install ghc -u 'https://gitlab.haskell.org/ghc/ghc/-/jobs/artifacts/master/raw/ghc-x86_64-linux-fedora33-release.tar.xz?job=x86_64-linux-fedora33-release' 9.15 --set

rm -rf \
  ~/.ghcup/cache \
  ~/.ghcup/ghc/head/share/doc \
  ~/.ghcup/ghc/head/share/man \
  ~/.ghcup/logs

find ~/.ghcup/ghc \( -name '*.p_hi' -o -name '*.p_dyn_hi' -o -name '*_p.a' -o -name '*_p.so' -o -name '*_p-ghc*.*.*.so' \) -type f -delete

cabal update

cabal install --ignore-project alex happy

./boot

./configure --enable-bootstrap-with-devel-snapshot --with-system-libffi

hadrian/build --version

echo :q | ./hadrian/ghci-multi

hadrian/build --flavour=quick-validate --docs=none -j binary-dist-dir test:all_deps

rm -rf \
  _build/bindist \
  ~/.cache/cabal/logs \
  ~/.cache/cabal/packages/hackage.haskell.org/01-index.tar.gz

find ~/.cache/cabal/packages/hackage.haskell.org -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} +

git -C $GITHUB_WORKSPACE ls-files -oi --exclude-standard -z \
  | sed -z "s|^|$GITHUB_WORKSPACE/|" >> /tmp/listing

git -C $GITHUB_WORKSPACE submodule foreach --quiet --recursive '
  git ls-files -oi --exclude-standard -z \
    | sed -z "s|^|$toplevel/$path/|" >> /tmp/listing
'

printf "%s\0" /root/.ghcup /root/.cache/cabal /root/.config/cabal /root/.local/bin /root/.local/state/cabal >> /tmp/listing

tar --create \
    --null --files-from=/tmp/listing \
    --absolute-names \
    --sort=name --owner=0 --group=0 --numeric-owner \
    --file=/workspace/ghc/codex-cache.tar

exec zstd -T0 --ultra -22 --rm /workspace/ghc/codex-cache.tar
