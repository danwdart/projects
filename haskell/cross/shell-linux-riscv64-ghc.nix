with import (builtins.fetchTarball "https://github.com/guibou/nixpkgs/archive/ghc-914.zip") {};
runCommand "haskell-cross-linux-riscv64" {
    buildInputs = [
      pkgsCross.riscv64.pkgsBuildHost.haskell.compiler.ghc914
    ];
} ""
