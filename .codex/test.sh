#!/usr/bin/env bash

set -euo pipefail

apt update

apt install -y \
  automake \
  libgmp-dev \
  zstd

unzstd --stdout codex-cache.tar.zst | tar x --absolute-names

. ~/.ghcup/env

echo :q | ./hadrian/ghci-multi

hadrian/build --flavour=quick-validate --docs=none -j --freeze1 test:all_deps
