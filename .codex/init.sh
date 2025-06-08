#!/usr/bin/env bash

set -euo pipefail

apt update

apt install -y \
  libgmp-dev \
  libtool-bin \
  zstd

curl -f -L --retry 5 https://github.com/haskell-ai/codex-ghc-dev/releases/download/250609-hls/ghc.tar.zst -o /tmp/ghc.tar.zst

unzstd --stdout /tmp/ghc.tar.zst | tar x -C /

rm /tmp/ghc.tar.zst
