with import <nixpkgs> {};
runCommand "asm-macOS-x86_64" {
    buildInputs = [
      darling-dmg
      gcc
      gnumake
      nasm
    ];
} ""
