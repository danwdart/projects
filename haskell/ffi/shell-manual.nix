with import <nixpkgs> {};
runCommand "ffi" {
    buildInputs = [
        pkgsMusl.gcc
        pkgsStatic.libffi
        pkgsStatic.gmp
        musl
        pkgsMusl.haskell.compiler.ghc910
        cabal-install
    ];
} ""