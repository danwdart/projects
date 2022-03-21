with import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {};
runCommand "uefi" {
    buildInputs = [
        gcc
        haskell.compiler.ghc922
        cabal-install
    ];
} ""