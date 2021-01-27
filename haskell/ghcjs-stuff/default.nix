{ nixpkgs ? import <nixpkgs> {},
  compiler ? "ghcjs" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      ghcjs-stuff = self.callCabal2nix "ghcjs-stuff" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.ghcjs-stuff
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
  exe = nixpkgs.haskell.lib.justStaticExecutables (myHaskellPackages.ghcjs-stuff);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  ghcjs-stuff = myHaskellPackages.ghcjs-stuff;
}