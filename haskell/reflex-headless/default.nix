{ nixpkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {},
  compiler ? "ghc8107" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      reflex-headless = self.callCabal2nix "reflex-headless" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.reflex-headless
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f); do krank $i; done
    '';
    buildInputs = with nixpkgs; with haskellPackages; [
      apply-refact
      cabal-install
      ghcid
      hlint
      implicit-hie
      krank
      stan
      stylish-haskell
      weeder
    ];
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.reflex-headless);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  reflex-headless = myHaskellPackages.reflex-headless;
}