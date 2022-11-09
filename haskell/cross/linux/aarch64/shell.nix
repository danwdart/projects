with import <nixpkgs> {};
runCommand "haskell-cross-linux-aarch64" {
    buildInputs = [
      pkgsCross.aarch64-multiplatform.pkgsBuildTarget.haskell.compiler.ghc94
    ];
} ""
