{ nixpkgs ? import  (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {},
  compiler ? "ghc901" }: # splitmix doesn't support 921 yet
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      onlyplatform = self.callCabal2nix "onlyplatform" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.onlyplatform
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f); do krank $i; done
    '';
    buildInputs = with nixpkgs; with haskellPackages; [
      apply-refact
      cabal-install
      ghcid
      hlint
      implicit-hie
      krank
      stan
      stylish-haskell
      weeder
    ];
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.onlyplatform);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  onlyplatform = myHaskellPackages.onlyplatform;
}
