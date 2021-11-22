{ nixpkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/refs/tags/19.09.tar.gz") {},
  compiler ? "ghc822" }: # basement etc
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      gpx-conduit = self.callHackage "gpx-conduit" "0.1.1" {};
      gps = self.callHackage "gps" "1.2" {};
      kmlfun = self.callCabal2nix "kmlfun" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.kmlfun
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f); do krank $i; done
    '';
    buildInputs = with myHaskellPackages; with nixpkgs; [
      apply-refact
      cabal-install
      ghcid
      haskell-language-server
      hlint
      implicit-hie
      krank
      stan
      stylish-haskell
      weeder
    ];
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.kmlfun);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  kmlfun = myHaskellPackages.kmlfun;
}