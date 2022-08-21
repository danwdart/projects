with import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/haskell-updates.tar.gz") {};
runCommand "haskell" {
    buildInputs = [
        haskell.compiler.ghc941
        haskell.packages.ghc941.cabal-install
    ];
} ""
