with import <nixpkgs> {};
runCommand "cli" {
    buildInputs = [
        (haskell.packages.ghc910.ghcWithPackages (ghc: with ghc; [ cabal-install ]))
    ];
} ""
