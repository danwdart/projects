#!/bin/sh
nix --extra-experimental-features nix-command --extra-experimental-features flakes shell https://gitlab.haskell.org/ghc/ghc-wasm-meta/-/archive/master/ghc-wasm-meta-master.tar.gz