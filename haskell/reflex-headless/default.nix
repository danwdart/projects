{ nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc884" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      reflex-headless = self.callCabal2nix "reflex-headless" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.reflex-headless
    ];
    buildInputs = [
      nixpkgs.haskellPackages.cabal-install
      nixpkgs.haskellPackages.stack
      nixpkgs.haskellPackages.ghcid
      nixpkgs.haskellPackages.stylish-haskell
      nixpkgs.haskellPackages.hlint
    ];
    withHoogle = true;
  };
  exe = nixpkgs.haskell.lib.justStaticExecutables (myHaskellPackages.reflex-headless);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  reflex-headless = myHaskellPackages.reflex-headless;
}