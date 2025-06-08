# `ghc`

## Typechecking GHC

Use `haskell-language-server typecheck ghc/Main.hs` to typecheck GHC
code without actually compiling it. When you put up a GHC patch,
always do this to ensure your patch typechecks.

## Building the GHC RTS

Use `hadrian/build --flavour=quick-validate --docs=none -j --freeze1 stage1:lib:rts`
to build the GHC RTS. If your patch touches the GHC RTS, always do
this to ensure your patch compiles properly.
