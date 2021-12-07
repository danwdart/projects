{ nixpkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {},
  compiler ? "ghc921" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      boardgames = self.callCabal2nix "boardgames" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.boardgames
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f); do krank $i; done
    '';
    buildInputs = with myHaskellPackages; with nixpkgs; with haskellPackages; [
      apply-refact
      cabal-install
      ghcid
      ghcide
      haskell-language-server
      hasktags
      hlint
      implicit-hie
      krank
      haskellPackages.stan # issue with 9.0.1
      stylish-haskell
      weeder
    ];
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.boardgames);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  boardgames = myHaskellPackages.boardgames;
}