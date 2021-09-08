with import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {};
runCommand "haskell" {
    buildInputs = [
        haskell.compiler.ghc921
        cabal-install
    ];
} ""