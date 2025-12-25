with import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.zip") {};
runCommand "haskell-cross-linux-aarch64" {
    buildInputs = [
      pkgsCross.aarch64-multiplatform.pkgsHostHost.gmp
      pkgsCross.aarch64-multiplatform.pkgsBuildHost.gcc
      pkgsCross.aarch64-multiplatform.pkgsBuildHost.haskell.compiler.ghc914
    ];
} ""
