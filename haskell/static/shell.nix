with import <nixpkgs> {};
runCommand "static" {
    buildInputs = [
        pkgsStatic.libffi
        pkgsStatic.gmp
        musl
        pkgsMusl.gcc
        pkgsMusl.haskell.compiler.ghc94
    ];
} ""