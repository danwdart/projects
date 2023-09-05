# ghcjs-stuff

## Building

nix run nixpkgs.cabal-install nixpkgs.pkgs.haskell.compiler.ghcjs nixpkgs.gcc nixpkgs.pkgs.haskellPackages.jsaddle
cabal v2-update
cabal --ghcjs build

## TODO

How to make this entirely nix & have binaries in nix?