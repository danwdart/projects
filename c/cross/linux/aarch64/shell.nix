with import <nixpkgs> {};
runCommand "c-cross-aarch64" {
    buildInputs = [
      pkgsCross.aarch64-multiplatform.pkgsBuildTarget.gcc
    ];
} ""
