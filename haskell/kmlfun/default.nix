{ nixpkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/refs/tags/19.09.tar.gz") {},
  compiler ? "ghc822" }: # basement etc
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
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
    buildInputs = [
      nixpkgs.haskellPackages.cabal-install
      nixpkgs.wget
      nixpkgs.haskellPackages.ghcid
      nixpkgs.haskellPackages.stylish-haskell
      nixpkgs.haskellPackages.hlint
    ];
    withHoogle = false;
  };
  exe = nixpkgs.haskell.lib.justStaticExecutables (myHaskellPackages.kmlfun);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  kmlfun = myHaskellPackages.kmlfun;
}