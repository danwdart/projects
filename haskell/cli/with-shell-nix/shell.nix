with import (builtins.fetchTarball "https://github.com/guibou/nixpkgs/archive/ghc-914.zip") {};
runCommand "cli" {
    buildInputs = [
        haskell.compiler.ghc914
        cabal-install
    ];
} ""
