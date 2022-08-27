with import <nixpkgs> {};
runCommand "asm-linux-x86_64" {
    buildInputs = [
      gcc
      gnumake
      nasm
    ];
} ""
