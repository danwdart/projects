with import <nixpkgs> {};
runCommand "static" {
    buildInputs = [
        pkgsStatic.libffi
        pkgsStatic.gmp
        musl
        pkgsMusl.haskell.compiler.ghc942
    ];
} ""