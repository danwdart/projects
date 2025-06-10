with import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/cf127972bbf111593f302e81ef3a9778da162fc4.tar.gz") {
    config = {
        allowUnsupportedSystem = true; # static elfutils requires this
    };
};
runCommand "static" {
    buildInputs = [
        cabal-install
        pkgsStatic.gmp
        pkgsStatic.libffi
        pkgsStatic.elfutils
        pkgsMusl.gcc # does a pkg-config?
        # pkgsStatic.gcc # does a pkg-config?
        pkgsMusl.haskell.compiler.ghc912
    ];
} ""