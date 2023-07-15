with import <nixpkgs> {};
runCommand "sls2" {
    buildInputs = [
        haskell.compiler.ghc96
        nodejs_18
        gcc
    ];
} ""

