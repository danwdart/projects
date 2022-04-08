with import <nixpkgs> {};
runCommand "demo" {
    buildInputs = [
      pkgsCross.mingwW64.pkgsBuildTarget.gcc
    ];
} ""
