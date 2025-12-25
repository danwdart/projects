with import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.zip") {};
runCommand "haskell" {
    buildInputs = [
        haskell.compiler.ghc914
        cabal-install
    ];
} ""
