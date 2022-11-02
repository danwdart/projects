{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  compiler ? "ghc942"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  tools = haskell-tools compiler;
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      hgettext = lib.markUnbroken super.hgettext;
      OpenGLRaw = lib.doJailbreak super.OpenGLRaw;
      gloss-rendering = lib.doJailbreak super.gloss-rendering;
      gloss = lib.doJailbreak super.gloss;
      # not released on nix yet
      req = self.callHackage "req" "3.13.0" {};
      # template-haskell >=2.11 && <2.19
      freer-simple = lib.doJailbreak super.freer-simple;
      sdl2 = lib.doJailbreak super.sdl2;
      text-display = lib.doJailbreak (lib.markUnbroken super.text-display);
      ilist = lib.doJailbreak super.ilist;
      other924 = lib.doBenchmark (lib.doCheck (lib.dontHaddock (self.callCabal2nix "other924" (gitignore ./.) {})));
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.other924
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools ++ [ nixpkgs.gettext ];
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.other924);
in
{
  inherit shell;
  other924 = lib.justStaticExecutables (myHaskellPackages.other924);
}
