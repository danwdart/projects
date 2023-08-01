with import <nixpkgs> {};
runCommand "js-backend" {
    buildInputs = [
        nodejs_20
        closurecompiler
        haskell.packages.ghc96.cabal-install
        (pkgsCross.ghcjs.haskell.packages.ghcHEAD.ghcWithPackages (ghc: with ghc; [
            ghcjs-base
            bytestring
            Cabal
            containers
            text
        ]))
    ];
    shellHook = ''
    '';
} ""
