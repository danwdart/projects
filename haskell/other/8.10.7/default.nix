{ nixpkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {},
  compiler ? "ghc8107" }:
  # ilist
  # th-expand-syns from aeson-qq
  # profunctors from lenses, sdl, shell-conduit and qchas
  # th from optics-th from optics and from hedgehog from unlift
  # basement from pizza, req and wai
  # hxt
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      other8107 = self.callCabal2nix "other8107" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.other8107
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
  exe = lib.justStaticExecutables (myHaskellPackages.other8107);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  other8107 = myHaskellPackages.other8107;
}
