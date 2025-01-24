{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  compiler ? "ghc910"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  tools = haskell-tools compiler;
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      #inline-asm = lib.doJailbreak (self.callCabal2nix "inline-asm" (builtins.fetchGit {
      #  url = "https://github.com/0xd34df00d/inline-asm.git";
      #  rev = "b75204581916caae8f8d7048b9f8ffba0623ed67";
      #}) {});
      #hgettext = lib.markUnbroken super.hgettext;
      #OpenGLRaw = lib.doJailbreak super.OpenGLRaw;
      # for linear-base
      # not yet in nix (only 1.1.0.0)
      #tasty-hedgehog = self.callHackage "tasty-hedgehog" "1.4.0.0" {};

      # not in nix yet
      #patch = lib.doJailbreak (self.callHackage "patch" "0.0.7.0" {});
      # https://github.com/reflex-frp/reflex/issues/482
      reflex-gloss = lib.doJailbreak (lib.markUnbroken super.reflex-gloss);
      # #gloss-rendering = lib.doJailbreak (self.callHackage "gloss-rendering" "1.13.1.2" {});
      # #gloss = lib.doJailbreak (self.callHackage "gloss" "1.13.2.2" {});
      # #hlint = self.callHackage "hlint" "3.5" {};
# 
      # #gloss-rendering = lib.doJailbreak super.gloss-rendering;
      # #gloss = lib.doJailbreak super.gloss;
      # # not released on nix yet
      # # template-haskell >=2.11 && <2.19
      # sdl2 = lib.doJailbreak super.sdl2;
      text-display = lib.doJailbreak (lib.markUnbroken super.text-display);
      ilist = lib.doJailbreak (lib.markUnbroken super.ilist);
      # #graphql = lib.doJailbreak super.graphql;
      # #http-api-data = lib.doJailbreak super.http-api-data;
      # linear-generics = lib.doJailbreak super.linear-generics;
      # #HaskellNet = lib.doJailbreak super.HaskellNet;
      # HGamer3D = lib.doJailbreak (lib.markUnbroken super.HGamer3D);
      # ghc-typelits-presburger = self.callHackage "ghc-typelits-presburger" "0.7.1.0" {};
      # ghc-typelits-natnormalise = self.callHackage "ghc-typelits-natnormalise" "0.7.7" {};
      dbus = lib.doJailbreak super.dbus;
      other910 = lib.doBenchmark (lib.doCheck (lib.dontHaddock (self.callCabal2nix "other910" (gitignore ./.) {})));
      bsb-http-chunked = lib.dontCheck super.bsb-http-chunked;
      gloss-rendering = lib.doJailbreak super.gloss-rendering;
      gloss = lib.doJailbreak super.gloss;
      graphql = lib.doJailbreak super.graphql;
      monads-tf = lib.doJailbreak super.monads-tf;
      freer-simple = self.callCabal2nix "freer-simple" (builtins.fetchGit {
        url = "https://github.com/georgefst/freer-simple.git";
        ref = "ghc-9.10";
        rev = "365bf9294477783b29186cdf48dc608e060a6ec9";
      }) {};
      patch = lib.doJailbreak super.patch;
      reflex = self.callCabal2nix "reflex" (nixpkgs.fetchFromGitHub {
        owner = "ymeister";
        repo = "reflex";
        rev = "844d88d10cbf0db8ad8677a9c72f6a10e811c0f4";
        sha256 = "EIMAtC4q+zvpckisAp6W1I8S4Lk1f70Yaii0tIhScQQ=";
      }) {};
      hgettext = lib.doJailbreak super.hgettext;
      # serialise = lib.dontCheck (lib.doJailbreak super.serialise);
      # serialise = null;
      # binary-serialise-cbor = null;
      # fresco-binding = null;
      http2 = lib.doJailbreak super.http2;
      microstache = lib.doJailbreak super.microstache;
      universe-base = lib.doJailbreak super.universe-base;
      universe-reverse-instances = lib.doJailbreak super.universe-reverse-instances;
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.other910
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools ++ [ nixpkgs.gettext nixpkgs.nodejs_20 nixpkgs.php82 ];
    withHoogle = false;
  };
  in
{
  inherit shell;
  other910 = lib.justStaticExecutables (myHaskellPackages.other910);
}
