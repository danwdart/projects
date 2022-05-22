with import <unstable> {};
runCommand "uefi" {
    buildInputs = [
        pkgsMusl.gcc
        pkgsStatic.libffi
        pkgsStatic.gmp
        musl
        pkgsMusl.haskell.compiler.ghc922
        cabal-install
    ];
} ""