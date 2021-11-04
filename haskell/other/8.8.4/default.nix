{ nixpkgs ? import  (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {},
  compiler ? "ghc884" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      inline-asm = self.callHackage "inline-asm" "0.4.0.2" {};
      # https://github.com/brendanhay/gogol/issues/148
      gogol-core = self.callCabal2nixWithOptions "gogol-core" (builtins.fetchGit { # not yet released
        url = "https://github.com/brendanhay/gogol";
        rev = "d7c7d71fc985cd96fb5f05173da6c607da362b74";
      }) "--subpath core" {};
      other884 = self.callCabal2nix "other884" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.other884
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
  exe = lib.justStaticExecutables (myHaskellPackages.other884);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  other884 = myHaskellPackages.other884;
}