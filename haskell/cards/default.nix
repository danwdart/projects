{ nixpkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {},
  compiler ? "ghc921" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      cards = self.callCabal2nix "cards" (gitignore ./.) {};
      # for stan
      cabal-doctest = lib.doJailbreak (self.callCabal2nix "cabal-doctest" (builtins.fetchGit {
        url = "https://github.com/haskellari/cabal-doctest.git";
        rev = "2338f86cbba06366fca42f7c9640bc408c940e0b";
      }) {});
      colourista = lib.doJailbreak super.colourista;
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.cards
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
      stan
      stylish-haskell
      haskellPackages.weeder # not on ghc 9.2 because of generic-lens-core issues
    ];
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.cards);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  cards = myHaskellPackages.cards;
}