with import <nixpkgs> {};
runCommand "cross-windows-x86_32" {
    buildInputs = [
      pkgsCross.mingw32.pkgsBuildTarget.gcc
    ];
} ""
