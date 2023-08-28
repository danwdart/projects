with import <nixpkgs> {};
runCommand "js-backend" {
    buildInputs = [
        nodejs_20
        closurecompiler
        (haskell.packages.ghc94.ghcWithPackages (ghc: with ghc; [
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
        (pkgsCross.ghcjs.haskell.packages.ghcHEAD.ghcWithPackages (ghc: with ghc; [
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
