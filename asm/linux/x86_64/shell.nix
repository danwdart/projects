with import <nixpkgs> {};
runCommand "x86_64" {
    buildInputs = [
      gcc
      gnumake
      nasm
    ];
} ""
