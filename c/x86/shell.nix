with import <nixpkgs> {};
runCommand "x86" {
    buildInputs = [
      gcc
      gdb
    ];
} ""
