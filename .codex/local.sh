#!/usr/bin/env bash

set -euo pipefail

exec podman run -it --rm --init --network host --pull always --tmpfs /tmp:exec ghcr.io/openai/codex-universal
