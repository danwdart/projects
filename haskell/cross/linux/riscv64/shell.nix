with import <nixpkgs> {};
runCommand "haskell-cross-linux-riscv64" {
    buildInputs = [
      pkgsCross.riscv64.pkgsBuildTarget.haskell.compiler.ghc94
    ];
} ""
