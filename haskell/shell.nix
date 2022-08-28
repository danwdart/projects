with import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/haskell-updates.tar.gz") {};
runCommand "haskell" {
    buildInputs = [
        haskell.compiler.ghc942
        haskell.packages.ghc942.cabal-install
    ];
} ""
