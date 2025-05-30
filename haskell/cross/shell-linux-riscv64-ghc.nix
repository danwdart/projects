with import <nixpkgs> {};
runCommand "haskell-cross-linux-riscv64" {
    buildInputs = [
      pkgsCross.riscv64.pkgsBuildHost.haskell.compiler.ghc912
    ];
} ""
