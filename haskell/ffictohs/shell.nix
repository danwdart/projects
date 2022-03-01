with import <nixpkgs> {};
runCommand "uefi" {
    buildInputs = [
        gcc
        haskell.compiler.ghc921
        cabal-install
    ];
} ""