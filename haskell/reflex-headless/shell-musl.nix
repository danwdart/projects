# https://hydra.nixos.org/job/nixpkgs/haskell-updates/haskell.compiler.ghc9122.x86_64-linux#tabs-status
with import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/cf127972bbf111593f302e81ef3a9778da162fc4.tar.gz") {};
# needs mkShell in order to use headers/etc. from deps! how do we do that from nix-shell 
mkShell rec {
    packages = [
        pkgsMusl.haskell.compiler.ghc912
        cabal-install
        # pkg-config
        # zlib.dev
        # pcre.dev
    ];
    # shellHook = ''
    #     [[ -f ~/.local/bin/refactor ]] || cabal install apply-refact cabal-fmt doctest ghci-dap ghcid ghcide haskell-debug-adapter haskell-language-server hasktags hlint hoogle hpack implicit-hie stan stylish-haskell weeder --overwrite-policy=always --allow-newer
    #     export PATH=~/.local/bin:$PATH
    #     gen-hie > hie.yaml
    #     for i in $(find -type f | grep -v "dist-*"); do krank $i; done
    # '';
}