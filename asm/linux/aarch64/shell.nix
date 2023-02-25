with import <nixpkgs> {};
runCommand "asm-linux-aarch64" {
    buildInputs = [
      #gcc
      gnumake
      nasm
      pkgsCross.aarch64-multiplatform.pkgsBuildHost.gcc
    ];
} ""
