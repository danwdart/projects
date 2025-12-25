# import "https://gitlab.haskell.org/ghc/ghc-wasm-meta/-/archive/master/ghc-wasm-meta-master.tar.gz"
with import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.zip") {};
runCommand "haskell" {
    buildInputs = [
        #clang
        #llvm
        #emscripten
        #binaryen
        gcc # for strip
        haskell.compiler.ghc914
        cabal-install
    ];
} ""
