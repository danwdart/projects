with import <nixpkgs> {};
runCommand "haskell" {
    buildInputs = [
        haskell.compiler.ghc96
        haskell.packages.ghc96.cabal-install
    ];
} ""
