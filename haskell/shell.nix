with import <nixpkgs> {};
runCommand "haskell" {
    buildInputs = [
        haskell.compiler.ghc912
        cabal-install
    ];
} ""
