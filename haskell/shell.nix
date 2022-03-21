with import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/haskell-updates.tar.gz") {};
runCommand "haskell" {
    buildInputs = [
        haskell.compiler.ghc922
        haskell.packages.ghc922.cabal-install
    ];
} ""
