with import <nixpkgs> {};
runCommand "demo" {
    buildInputs = [
      gcc
      binutils
      gnumake
    ];
} ""
