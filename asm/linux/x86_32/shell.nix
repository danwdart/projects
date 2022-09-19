with import <nixpkgs> {};
runCommand "asm-linux-x86_32" {
    buildInputs = [
      gcc
      gnumake
      nasm
    ];
} ""
