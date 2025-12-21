# import "https://gitlab.haskell.org/ghc/ghc-wasm-meta/-/archive/master/ghc-wasm-meta-master.tar.gz"
with import (builtins.fetchTarball "https://github.com/guibou/nixpkgs/archive/ghc-914.zip") {};
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
