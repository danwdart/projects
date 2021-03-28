{ nixpkgs ? import (fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz) {},
  compiler ? "ghc8104" }: # basement's base is 4.14 and can't be jailbroken because of unsafeCoerce#
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      digits = (self.callHackage "digits" "0.3.1" {}).overrideDerivation (self: {
        prePatch = ''
          echo -e "> import Distribution.Simple\n> main = defaultMain" > Setup.lhs
        '';
      });
      factory = self.callHackage "factory" "0.3.2.2" {};
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