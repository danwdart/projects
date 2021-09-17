{ nixpkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {},
  compiler ? "ghc901" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      digits = (self.callHackage "digits" "0.3.1" {}).overrideDerivation (self: {
        prePatch = ''
          echo -e "> import Distribution.Simple\n> main = defaultMain" > Setup.lhs
        '';
      });
      factory = self.callHackage "factory" "0.3.2.2" {};
      partial-isomorphisms = self.callHackage "partial-isomorphisms" "0.2.3.0" {};
      exact-pi = nixpkgs.pkgs.haskell.lib.doJailbreak super.exact-pi;
      req = nixpkgs.pkgs.haskell.lib.doJailbreak (self.callHackage "req" "3.9.1" {});
      text-short = nixpkgs.pkgs.haskell.lib.overrideCabal super.text-short (drv: {
        doCheck = false;
      });
      maths = self.callCabal2nix "maths" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.maths
    ];
    buildInputs = [
      nixpkgs.haskellPackages.cabal-install
      nixpkgs.wget
      nixpkgs.haskellPackages.ghcid
      nixpkgs.haskellPackages.stylish-haskell
      nixpkgs.haskellPackages.hlint
    ];
    withHoogle = false;
  };
  exe = nixpkgs.haskell.lib.justStaticExecutables (myHaskellPackages.maths);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  maths = myHaskellPackages.maths;
}