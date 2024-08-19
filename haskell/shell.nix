with import <nixpkgs> {};
runCommand "haskell" {
    buildInputs = [
        (haskell.packages.ghc98.ghcWithPackages (ghc: with ghc; [ cabal-install ]))
    ];
} ""
