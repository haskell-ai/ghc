# `ghc`

## Setting up the build environment

This is the source repository of GHC, and you need to execute these
steps in the interactive bash session exactly once, to set up the
build environment:

1. Run `git submodule update --init --depth=1 --jobs=32` to initialize
   all submodules.
2. Then, execute `./.codex/init.sh` in the repository root directory.
   It will take quite a bit of time to initialize necessary tools to
   build GHC, do not interrupt!
3. Then, do `. ~/.ghcup/env` to make sure the build tools are
   available in `PATH`.

Afterwards, you can typecheck or actually build/test GHC using the
instructions below.

## Typechecking GHC

Use `haskell-language-server typecheck ghc/Main.hs` to typecheck GHC
code without actually compiling it. When you put up a GHC patch,
always do this to ensure your patch typechecks. Do not interrupt this
step, the output may appear as if the command is stuck, but GHC is
indeed running.

## Building/testing GHC

Use `hadrian/build --flavour=quick-validate --docs=none -j --freeze1 test --only="TEST1 TEST2 ..."`
to actually build GHC and test it against specific test cases `TEST1`,
`TEST2`, etc. The test case names are space delimited and wrapped in
`""`. Do not run the whole testsuite as it will exceed your time
limit, only test against relevant test cases. Do not interrupt this
step, let it run till your maximum time limit.
