with import <nixpkgs> {};
runCommand "asm-os-8086" {
    buildInputs = [
      #gcc
      gnumake
      nasm
      qemu
    ];
} ""
