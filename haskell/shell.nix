with import <nixpkgs> {};
runCommand "haskell" {
    buildInputs = [
        haskell.compiler.ghc92
        haskell.packages.ghc92.cabal-install
    ];
} ""
