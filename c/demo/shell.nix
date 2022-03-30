with import <nixpkgs> {};
runCommand "demo" {
    buildInputs = [
      gcc
    ];
} ""
