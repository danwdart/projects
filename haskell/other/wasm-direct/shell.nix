with import "https://gitlab.haskell.org/ghc/ghc-wasm-meta/-/archive/master/ghc-wasm-meta-master.tar.gz" {};
runCommand "haskell" {
    buildInputs = [
        #clang
        #llvm
        #emscripten
        #binaryen
        gcc # for strip
        (haskell.packages.ghcHEAD.ghcWithPackages (self: with self; [
        ]))
    ];
} ""
