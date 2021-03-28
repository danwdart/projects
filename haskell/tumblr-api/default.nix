{ nixpkgs ? import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz) {},
  compiler ? "ghc8104" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      humblr = self.callCabal2nix "humblr" (builtins.fetchGit {
        url = "https://github.com/danwdart/humblr.git";
        rev = "22b065ead87cb1c3c19545c54f8ff90fb1e314e9";
      }) {};
      tumblr-api = self.callCabal2nix "tumblr-api" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.tumblr-api
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
  exe = nixpkgs.haskell.lib.justStaticExecutables (myHaskellPackages.tumblr-api);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  tumblr-api = myHaskellPackages.tumblr-api;
}
