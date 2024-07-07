with import <nixpkgs> {};
runCommand "haskell-cross-linux-x86_64" {
    buildInputs = [
      pkgsCross.gnu64.pkgsHostHost.gmp
      pkgsCross.gnu64.pkgsBuildHost.gcc
      pkgsCross.gnu64.pkgsBuildHost.haskell.compiler.ghc98
    ];
} ""
