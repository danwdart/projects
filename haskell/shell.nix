with import <nixpkgs> {};
runCommand "haskell" {
    buildInputs = [
        haskell.compiler.ghc98
        haskell.packages.ghc98.cabal-install
    ];
} ""
