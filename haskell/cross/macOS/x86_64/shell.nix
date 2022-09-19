with import <nixpkgs> {};
runCommand "haskell-cross-macOS-x86_64" {
    buildInputs = [
      pkgsCross.x86_64-darwin.pkgsBuildTarget.haskell.compiler.ghc942
    ];
} ""
