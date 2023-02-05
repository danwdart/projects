with import <nixpkgs> {};
runCommand "haskell-cross-windows-x86_64" {
    buildInputs = [
      pkgsCross.mingwW64.pkgsBuildTarget.haskell.compiler.ghc92
    ];
} ""
