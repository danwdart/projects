with import <nixpkgs> {};
runCommand "haskell-cross-windows-x86_32" {
    buildInputs = [
      pkgsCross.mingw32.pkgsBuildTarget.haskell.compiler.ghc942
    ];
} ""
