with import <unstable> {};
runCommand "static" {
    buildInputs = [
        pkgsStatic.libffi
        pkgsStatic.gmp
        musl
        pkgsMusl.haskell.compiler.ghc923
    ];
} ""