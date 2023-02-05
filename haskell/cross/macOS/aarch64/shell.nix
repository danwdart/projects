with import <nixpkgs> {};
runCommand "haskell-cross-macOS-aarch64" {
    buildInputs = [
      pkgsCross.aarch64-darwin.pkgsBuildTarget.haskell.compiler.ghc92
    ];
} ""
