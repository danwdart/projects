{ nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc910" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      #gpx-conduit = lib.doJailbreak (self.callHackage "gpx-conduit" "0.1.1" {});
      #gps = lib.doJailbreak (self.callHackage "gps" "1.2" {});
      kmlfun = lib.dontHaddock (self.callCabal2nix "kmlfun" (gitignore ./.) {});
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.kmlfun
    ];
    shellHook = ''
    '';
    buildInputs = with myHaskellPackages; with nixpkgs; with haskellPackages; [
      # apply-refact
      # cabal-install
      # ghcid
      # haskellPackages.haskell-language-server # doesn't exist in ghc822
      # hasktags
      # hlint
      # implicit-hie # doesn't exist in ghc822
      # krank # doesn't exist in ghc822
      # stan #  # doesn't exist in ghc822
      # stylish-haskell
      # weeder
    ];
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.kmlfun);
in
{
  inherit shell;
  kmlfun = lib.justStaticExecutables (myHaskellPackages.kmlfun);
}