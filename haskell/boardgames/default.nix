{ nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc8102" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      websites = self.callCabal2nix "boardgames" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.websites
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
  exe = nixpkgs.haskell.lib.justStaticExecutables (myHaskellPackages.websites);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  websites = myHaskellPackages.websites;
}