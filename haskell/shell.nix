with import <nixpkgs> {};
runCommand "haskell" {
    buildInputs = [
        (haskell.packages.ghc910.ghcWithPackages (ghc: with ghc; [ cabal-install ]))
    ];
} ""
