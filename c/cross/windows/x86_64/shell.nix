with import <nixpkgs> {};
runCommand "cross-windows-x86_64" {
    buildInputs = [
      pkgsCross.mingwW64.pkgsBuildHost.gcc
    ];
} ""
