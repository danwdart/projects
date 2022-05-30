with import <unstable> {};
runCommand "haskell" {
    buildInputs = [
        haskell.compiler.ghc923
        haskell.packages.ghc923.cabal-install
    ];
} ""
