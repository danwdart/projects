with import <nixpkgs> {};
runCommand "uefi" {
    buildInputs = [
        gcc
        haskell.compiler.ghc922
        cabal-install
    ];
} ""