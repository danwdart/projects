with import <nixpkgs> {};
runCommand "haskell" {
    buildInputs = [
        haskell.compiler.ghc94
        haskell.packages.ghc94.cabal-install
    ];
} ""
