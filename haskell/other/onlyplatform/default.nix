{ nixpkgs ? import <unstable> {},
  compiler ? "ghc901" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      onlyplatform = self.callCabal2nix "onlyplatform" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.onlyplatform
    ];
    buildInputs = [
      nixpkgs.haskellPackages.cabal-install
      nixpkgs.wget
      nixpkgs.haskellPackages.stack
      nixpkgs.haskellPackages.ghcid
      nixpkgs.haskellPackages.stylish-haskell
      nixpkgs.haskellPackages.hlint
    ];
    withHoogle = false;
  };
  exe = nixpkgs.haskell.lib.justStaticExecutables (myHaskellPackages.onlyplatform);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  onlyplatform = myHaskellPackages.onlyplatform;
}
