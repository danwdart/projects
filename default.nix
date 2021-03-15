with import <nixpkgs> {};

runCommand "projects" {
    buildInputs = [
        cachix
        git
    ];
} "nix-channel --update"