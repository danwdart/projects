with import <nixpkgs> {};
runCommand "functional" {
    buildInputs = [
      gcc
    ];
} ""
