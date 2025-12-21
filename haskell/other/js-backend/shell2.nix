with import (builtins.fetchTarball "https://github.com/guibou/nixpkgs/archive/ghc-914.zip") {};
runCommand "js-backend" {
    buildInputs = [
        nodejs_20
        closurecompiler
        (haskell.packages.ghc914.ghcWithPackages (ghc: with ghc; [
            array
            base
            bytestring
            cabal-install
            Cabal
            containers
            deepseq
            directory
            filepath
            mtl
            process
            stm
            template-haskell
            text
            unix
            ghcjs-base
        ]))
        (pkgsCross.ghcjs.haskell.packages.ghc914.ghcWithPackages (ghc: with ghc; [
            array
            base
            bytestring
            Cabal
            containers
            deepseq
            directory
            filepath
            mtl
            process
            stm
            template-haskell
            text
            unix
            ghcjs-base
        ]))
    ];
    shellHook = ''
    '';
} ""
