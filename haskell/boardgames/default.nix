{ nixpkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {},
  compiler ? "ghc8107" }: # basement etc
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      boardgames = self.callCabal2nix "boardgames" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.boardgames
    ];
    buildInputs = [
      nixpkgs.haskellPackages.cabal-install
      nixpkgs.wget
      nixpkgs.haskellPackages.ghcid
      nixpkgs.haskellPackages.stylish-haskell
      nixpkgs.haskellPackages.hlint
    ];
    withHoogle = true;
  };
  exe = nixpkgs.haskell.lib.justStaticExecutables (myHaskellPackages.boardgames);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  boardgames = myHaskellPackages.boardgames;
}