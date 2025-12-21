with import (builtins.fetchTarball "https://github.com/guibou/nixpkgs/archive/ghc-914.zip") {};
runCommand "haskell-cross-linux-aarch64" {
    buildInputs = [
      pkgsCross.aarch64-multiplatform.pkgsHostHost.gmp
      pkgsCross.aarch64-multiplatform.pkgsBuildHost.gcc
      pkgsCross.aarch64-multiplatform.pkgsBuildHost.haskell.compiler.ghc914
    ];
} ""
