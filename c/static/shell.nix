with import <nixpkgs> {};
runCommand "static" {
    buildInputs = [
        pkgsMusl.gcc # or gcc
        musl
    ];
} ""