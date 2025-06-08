#!/usr/bin/env bash

set -euo pipefail

apt update

apt install -y \
  automake \
  libgmp-dev \
  zstd

curl -f -L --retry 5 https://github.com/haskell-ai/ghc/releases/download/lkgr-codex/codex-cache.tar.zst -O

unzstd --stdout codex-cache.tar.zst | tar x --absolute-names

exec rm codex-cache.tar.zst
