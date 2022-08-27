with import <nixpkgs> {};
runCommand "asm-macOS-x86_32" {
    buildInputs = [
      darling-dmg
      gcc
      gnumake
      nasm
    ];
} ""
