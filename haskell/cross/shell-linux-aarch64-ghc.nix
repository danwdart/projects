with import <nixpkgs> {};
runCommand "haskell-cross-linux-aarch64" {
    buildInputs = [
      pkgsCross.aarch64-multiplatform.pkgsHostHost.gmp
      pkgsCross.aarch64-multiplatform.pkgsBuildHost.gcc
      pkgsCross.aarch64-multiplatform.pkgsBuildHost.haskell.compiler.ghc910
    ];
} ""
