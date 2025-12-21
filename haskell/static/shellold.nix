with import (builtins.fetchTarball "https://github.com/guibou/nixpkgs/archive/ghc-914.zip") {
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
        pkgsMusl.haskell.compiler.ghc914
    ];
} ""