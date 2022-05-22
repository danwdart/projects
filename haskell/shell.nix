with import <unstable> {};
runCommand "haskell" {
    buildInputs = [
        haskell.compiler.ghc922
        haskell.packages.ghc922.cabal-install
    ];
} ""
