# cabal repl

Use flags:
    `cabal repl PACKAGE --ghc-options="-Wno-missing-local-signatures"

# "other" packages

These are experiments to see what I can do with packages outside of base and core.

## Benchmark

Graphical benchmark results:

```sh
cabal bench --benchmark-options="-o report.html"
xdg-open report.html
```