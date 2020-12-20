{ nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc8102" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      tumblr-editor = self.callCabal2nix "tumblr-editor" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.tumblr-editor
    ];
    buildInputs = [
      nixpkgs.haskellPackages.cabal-install
      nixpkgs.haskellPackages.wget
      nixpkgs.haskellPackages.stack
      nixpkgs.haskellPackages.ghcid
      nixpkgs.haskellPackages.stylish-haskell
      nixpkgs.haskellPackages.hlint
    ];
    withHoogle = true;
  };
  exe = nixpkgs.haskell.lib.justStaticExecutables (myHaskellPackages.tumblr-editor);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  tumblr-editor = myHaskellPackages.tumblr-editor;
}
