{ nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc884" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      inline-asm = self.callCabal2nix "inline-asm" (builtins.fetchGit {
        url = "https://github.com/0xd34df00d/inline-asm.git";
        rev = "f41ce27170fd919bd711d6b78a9f614f7d978b6e";
      }) {};
      other884 = self.callCabal2nix "other884" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.other884
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
  exe = nixpkgs.haskell.lib.justStaticExecutables (myHaskellPackages.other884);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  other884 = myHaskellPackages.other884;
}