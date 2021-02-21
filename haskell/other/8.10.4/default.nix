{ nixpkgs ? import <nixpkgs> {},
  compiler ? "ghc8104" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      other8104 = self.callCabal2nix "other8104" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.other8104
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
  exe = nixpkgs.haskell.lib.justStaticExecutables (myHaskellPackages.other8104);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  other8104 = myHaskellPackages.other8104;
}
