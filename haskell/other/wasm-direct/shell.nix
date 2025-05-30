# import "https://gitlab.haskell.org/ghc/ghc-wasm-meta/-/archive/master/ghc-wasm-meta-master.tar.gz"
with import <nixpkgs> {};
runCommand "haskell" {
    buildInputs = [
        #clang
        #llvm
        #emscripten
        #binaryen
        gcc # for strip
        haskell.compiler.ghc912
        cabal-install
    ];
} ""
