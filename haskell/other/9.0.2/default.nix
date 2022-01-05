{ nixpkgs ? import  (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/haskell-updates.tar.gz") {},
  compiler ? "ghc902" }:
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
      dbus = lib.doJailbreak super.dbus;
      req = lib.doJailbreak (self.callHackage "req" "3.9.2" {});
      other902 = self.callCabal2nix "other902" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.other902
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f); do krank $i; done
    '';
    buildInputs = with myHaskellPackages; with nixpkgs; with haskellPackages; [
      apply-refact
      cabal-install
      ghcid
      haskell-language-server
      hasktags
      hlint
      implicit-hie
      krank
      stan
      stylish-haskell
      weeder
    ];
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.other902);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  other902 = myHaskellPackages.other902;
}