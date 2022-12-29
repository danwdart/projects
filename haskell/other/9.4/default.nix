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
      inline-asm = lib.doJailbreak (self.callCabal2nix "inline-asm" (builtins.fetchGit {
        url = "https://github.com/0xd34df00d/inline-asm.git";
        rev = "b75204581916caae8f8d7048b9f8ffba0623ed67";
      }) {});
      hgettext = lib.markUnbroken super.hgettext;
      OpenGLRaw = lib.doJailbreak super.OpenGLRaw;
      # for linear-base
      # not yet in nix (only 1.1.0.0)
      tasty-hedgehog = self.callHackage "tasty-hedgehog" "1.4.0.0" {};

      # not in nix yet
      patch = lib.doJailbreak (self.callHackage "patch" "0.0.7.0" {});
      # https://github.com/reflex-frp/reflex/issues/482
      reflex = lib.disableCabalFlag (lib.doJailbreak (self.callHackage "reflex" "0.8.2.1" {})) "use-template-haskell";
      # not in nix yet
      reflex-gloss = lib.doJailbreak (lib.markUnbroken super.reflex-gloss);
      #gloss-rendering = lib.doJailbreak (self.callHackage "gloss-rendering" "1.13.1.2" {});
      #gloss = lib.doJailbreak (self.callHackage "gloss" "1.13.2.2" {});
      hlint = self.callHackage "hlint" "3.5" {};

      gloss-rendering = lib.doJailbreak super.gloss-rendering;
      gloss = lib.doJailbreak super.gloss;
      # not released on nix yet
      req = self.callHackage "req" "3.13.0" {};
      # template-haskell >=2.11 && <2.19
      freer-simple = lib.doJailbreak super.freer-simple;
      sdl2 = lib.doJailbreak super.sdl2;
      text-display = lib.doJailbreak (lib.markUnbroken super.text-display);
      ilist = lib.doJailbreak super.ilist;
      graphql = lib.doJailbreak super.graphql;
      http-api-data = lib.doJailbreak super.http-api-data;
      linear-generics = lib.doJailbreak super.linear-generics;
      other94 = lib.doBenchmark (lib.doCheck (lib.dontHaddock (self.callCabal2nix "other94" (gitignore ./.) {})));
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.other94
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools ++ [ nixpkgs.gettext ];
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.other94);
in
{
  inherit shell;
  other94 = lib.justStaticExecutables (myHaskellPackages.other94);
}
