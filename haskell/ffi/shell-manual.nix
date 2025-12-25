with import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.zip") {};
runCommand "ffi" {
    buildInputs = [
        pkgsMusl.gcc
        pkgsStatic.libffi
        pkgsStatic.gmp
        musl
        pkgsMusl.haskell.compiler.ghc914
        cabal-install
    ];
} ""