with import <nixpkgs> {};
runCommand "haskell" {
    buildInputs = [
        haskell.compiler.ghc942
        haskell.packages.ghc942.cabal-install
    ];
} ""
