# `ghc`

## Setting up the build environment

This is the source repository of GHC, and you need to execute these
steps in the interactive bash session exactly once, to set up the
build environment:

1. Run `git -c protocol.version=2 submodule update --init --depth=1 --jobs=32`
   to initialize all submodules.
2. Then, execute `./.codex/init.sh` in the repository root directory.
   It will take quite a bit of time to initialize necessary tools to
   build GHC, do not interrupt!
3. Then, do `. ~/.ghcup/env` to make sure the build tools are
   available in `PATH`.

Afterwards, you can typecheck GHC using the instructions below.

## Typechecking GHC

Use `echo :q | ./hadrian/ghci-multi` to typecheck GHC code without
actually compiling it. When you put up a GHC patch, always do this to
ensure your patch typechecks. Do not interrupt this step, the output
may appear as if the command is stuck, but GHC is indeed running.
