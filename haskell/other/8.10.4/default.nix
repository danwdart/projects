{ nixpkgs ? import <unstable> {},
  compiler ? "ghc8104" }:
  # ilist
  # th-expand-syns from aeson-qq
  # profunctors from lenses, sdl, shell-conduit and qchas
  # th from optics-th from optics and from hedgehog from unlift
  # basement from pizza, req and wai
  # hxt
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
