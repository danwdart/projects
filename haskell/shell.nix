with import <nixpkgs> {};
runCommand "VMs" {
    buildInputs = [
        haskell.compiler.ghc901
        cabal-install
    ];
} ""
