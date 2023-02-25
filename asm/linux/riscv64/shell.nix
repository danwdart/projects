with import <nixpkgs> {};
runCommand "asm-linux-riscv64" {
    buildInputs = [
      #gcc
      gnumake
      nasm
      pkgsCross.riscv64.pkgsBuildHost.gcc
    ];
} ""
