with import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/haskell-updates.tar.gz") {};
runCommand "haskell" {
    buildInputs = [
        haskell.compiler.ghc923
        haskell.packages.ghc923.cabal-install
    ];
} ""
