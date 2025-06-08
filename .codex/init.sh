#!/usr/bin/env bash

set -euo pipefail

apt update

apt install -y \
  automake \
  libgmp-dev \
  zstd

curl -f -L --retry 5 https://github.com/haskell-ai/ghc/releases/download/lkgr-wasm-ncg-ppr-error/codex-cache.tar.zst -O

unzstd --stdout codex-cache.tar.zst | tar x --absolute-names

rm codex-cache.tar.zst

. ~/.ghcup/env

exec cabal update
