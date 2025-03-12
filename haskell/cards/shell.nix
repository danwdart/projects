with import (builtins.fetchTarball 
    "https://github.com/NixOS/nixpkgs/archive/refs/heads/haskell-updates.tar.gz"
) {};
# needs mkShell in order to use headers/etc. from deps! how do we do that from nix-shell 
mkShell rec {
    packages = [
        haskell.compiler.ghc912
        haskell.packages.ghc912.cabal-install
    ];
    # maybe we can include the copy to store stuff in here? as mkShell is a custom stdenv.mkDerivation
    # shellHook = ''
    #     export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath buildInputs}:$LD_LIBRARY_PATH"
    #     export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib.outPath}/lib:$LD_LIBRARY_PATH"
    # '';
}