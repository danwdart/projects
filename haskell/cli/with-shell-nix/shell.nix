with import <nixpkgs> {};
runCommand "cli" {
    buildInputs = [
        haskell.compiler.ghc912
        cabal-install
    ];
} ""
