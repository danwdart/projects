with import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.zip") {};
runCommand "yt-sort" {
    buildInputs = [
        (haskell.packages.ghc914.ghcWithPackages (ghc: with ghc; [
            # apply-refact
            # cabal-fmt
            cabal-install
            # doctest
            # ghci-dap
            # ghcid
            # ghcide
            # haskell-dap
            # haskell-debug-adapter
            # haskell-language-server
            # hasktags
            # hlint
            # hoogle
            # hpack
            # # hpack-convert # broken in all versions
            implicit-hie
            # # krank # broken
            # stack
            # # stan # broken in all versions
            # stylish-haskell
            # weeder
        ]))
    ];
    shellHook = ''
        gen-hie > hie.yaml
        for i in $(find . -type f | grep -v "dist-*"); do krank $i; done
    '';
} ""

