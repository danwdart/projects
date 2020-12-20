{ nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc8102" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      factory = self.callCabal2nix "factory" (builtins.fetchGit {
        url = "https://github.com/functionalley/Factory.git";
        rev = "fb3bac4d3722320d5de50943fc3bbb79a7de11f7";
      }) {};
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
      nixpkgs.haskellPackages.stack
      nixpkgs.haskellPackages.ghcid
      nixpkgs.haskellPackages.stylish-haskell
      nixpkgs.haskellPackages.hlint
    ];
    withHoogle = true;
  };
  exe = nixpkgs.haskell.lib.justStaticExecutables (myHaskellPackages.maths);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  maths = myHaskellPackages.maths;
}