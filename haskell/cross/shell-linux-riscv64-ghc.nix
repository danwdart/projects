with import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.zip") {};
runCommand "haskell-cross-linux-riscv64" {
    buildInputs = [
      pkgsCross.riscv64.pkgsBuildHost.haskell.compiler.ghc914
    ];
} ""
