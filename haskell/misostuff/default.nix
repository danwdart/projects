{ nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc884" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      misostuff = self.callCabal2nix "misostuff" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.misostuff
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
  exe = nixpkgs.haskell.lib.justStaticExecutables (myHaskellPackages.misostuff);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  misostuff = myHaskellPackages.misostuff;
}