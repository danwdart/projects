with import <nixpkgs> {};
runCommand "c-cross-riscv64" {
    buildInputs = [
      pkgsCross.riscv64.pkgsBuildHost.gcc
    ];
} ""
