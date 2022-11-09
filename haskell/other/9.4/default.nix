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
      hgettext = lib.markUnbroken super.hgettext;
      OpenGLRaw = lib.doJailbreak super.OpenGLRaw;
      # for linear-base
      # not yet in nix (only 1.1.0.0)
      tasty-hedgehog = self.callHackage "tasty-hedgehog" "1.4.0.0" {};
      gloss-rendering = lib.doJailbreak super.gloss-rendering;
      gloss = lib.doJailbreak super.gloss;
      # not released on nix yet
      req = self.callHackage "req" "3.13.0" {};
      # template-haskell >=2.11 && <2.19
      freer-simple = lib.doJailbreak super.freer-simple;
      sdl2 = lib.doJailbreak super.sdl2;
      text-display = lib.doJailbreak (lib.markUnbroken super.text-display);
      ilist = lib.doJailbreak super.ilist;
      other92 = lib.doBenchmark (lib.doCheck (lib.dontHaddock (self.callCabal2nix "other92" (gitignore ./.) {})));
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.other92
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools ++ [ nixpkgs.gettext ];
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.other92);
in
{
  inherit shell;
  other92 = lib.justStaticExecutables (myHaskellPackages.other92);
}
