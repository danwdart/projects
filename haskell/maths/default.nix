{ nixpkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {},
  compiler ? "ghc901" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      digits = (self.callHackage "digits" "0.3.1" {}).overrideDerivation (self: {
        prePatch = ''
          echo -e "> import Distribution.Simple\n> main = defaultMain" > Setup.lhs
        '';
      });
      factory = self.callHackage "factory" "0.3.2.2" {};
      partial-isomorphisms = self.callHackage "partial-isomorphisms" "0.2.3.0" {};
      exact-pi = lib.doJailbreak super.exact-pi;
      req = lib.doJailbreak (self.callHackage "req" "3.9.1" {});
      text-short = lib.overrideCabal super.text-short (drv: {
        doCheck = false;
      });
      maths = self.callCabal2nix "maths" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.maths
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
      hlint
      implicit-hie
      krank
      haskellPackages.stan # issue with 9.0.1
      stylish-haskell
      weeder
    ];
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.maths);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  maths = myHaskellPackages.maths;
}