with import (builtins.fetchTarball "https://github.com/guibou/nixpkgs/archive/ghc-914.zip") {};
runCommand "haskell-cross-linux-x86_64" {
    buildInputs = [
      pkgsCross.gnu64.pkgsHostHost.gmp
      pkgsCross.gnu64.pkgsBuildHost.gcc
      pkgsCross.gnu64.pkgsBuildHost.haskell.compiler.ghc914
    ];
} ""
