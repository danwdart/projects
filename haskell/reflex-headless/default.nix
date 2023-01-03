{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  compiler ? "ghc94"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  tools = haskell-tools compiler;
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      reflex-headless = lib.dontHaddock (self.callCabal2nix "reflex-headless" (gitignore ./.) {});
      reflex = lib.doJailbreak (self.callHackage "reflex" "0.9.0.0" {});
      # not in nix yet
      patch = lib.doJailbreak (self.callHackage "patch" "0.0.7.0" {});
      # not in nix yet
      # https://github.com/reflex-frp/reflex/issues/482
      # reflex = lib.disableCabalFlag (lib.doJailbreak (self.callHackage "reflex" "0.8.2.1" {})) "use-template-haskell";
      # not in nix yet
      hlint = self.callHackage "hlint" "3.5" {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.reflex-headless
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools;
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.reflex-headless);
in
{
  inherit shell;
  reflex-headless = lib.justStaticExecutables (myHaskellPackages.reflex-headless);
}