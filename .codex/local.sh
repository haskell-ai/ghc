#!/usr/bin/env bash

set -euo pipefail

exec podman run -it --rm --init --network host --pull always --tmpfs /tmp:exec --volume "$PWD":/workspace/ghc --workdir /workspace/ghc ghcr.io/openai/codex-universal
