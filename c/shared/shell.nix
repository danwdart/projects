with import <nixpkgs> {};
runCommand "shared" {
    buildInputs = [
      gcc
    ];
} ""
