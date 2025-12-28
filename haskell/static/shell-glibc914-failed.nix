with import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.zip") {};
# needs mkShell in order to use headers/etc. from deps! how do we do that from nix-shell 
mkShell rec {
    packages = [
        cabal-install
        pkgsStatic.libffi
        # pkgsStatic.gcc # does a pkg-config?
        # native-bignum because gmp is lgpl and can't go static with a potentially proprietary module
        haskell.compiler.native-bignum.ghc914 # no >=9.6 because it suddenly does a screw around with elfutils which doesn't seem to have good .a files
        # you can do better with alpine!!
    ];
    shellHook = ''
    '';
}