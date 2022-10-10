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
      bmp = lib.doJailbreak super.bmp;
      carray = lib.doJailbreak super.carray;
      flow = lib.doJailbreak super.flow;
      hgettext = lib.markUnbroken super.hgettext;
      # hgettext = self.callHackage "hgettext" "0.1.40.1" {};
      OpenGLRaw = lib.doJailbreak super.OpenGLRaw;
      OpenGL = lib.doJailbreak super.OpenGL;
      gloss-rendering = lib.doJailbreak super.gloss-rendering;
      gloss = lib.doJailbreak super.gloss;
      readable = lib.doJailbreak super.readable;
      # not released on nix yet
      req = self.callHackage "req" "3.13.0" {};
      # template-haskell >=2.11 && <2.19
      freer-simple = lib.doJailbreak super.freer-simple;
      sdl2 = lib.doJailbreak super.sdl2; # reflex it!
      # https://github.com/well-typed/generics-sop/pull/147
      sop-core = (lib.doJailbreak (self.callCabal2nixWithOptions "sop-core" (builtins.fetchGit {
        url = "https://github.com/danwdart/generics-sop.git";
        rev = "39386037d49bd21871a6479eaba9f4d5f4dbdf10";
      }) "--subpath sop-core" {}));
      io-streams-haproxy = lib.doJailbreak super.io-streams-haproxy;
      openssl-streams = lib.doJailbreak super.openssl-streams;
      # Setup: Encountered missing or private dependencies:
      # hashable >=1.2.0.6 && <1.4
      snap-core = lib.dontCheck (lib.doJailbreak (self.callCabal2nix "snap-core" (builtins.fetchGit {
        url = "https://github.com/snapframework/snap-core.git";
        ref = "bd2f6ec93d509c986010da5a6fc32d79cf686621";
      }) {}));
      snap-server = lib.doJailbreak super.snap-server;
      websockets-snap = lib.doJailbreak super.websockets-snap;
      text-display = lib.doJailbreak (lib.markUnbroken super.text-display);
      # not there?
      # Cabal = self.callHackage "Cabal" "3.8.1.0" {};
      # not there?
      # parsec = lib.doJailbreak (self.callHackage "parsec" "3.1.15.0" {});
      # hashable = lib.doJailbreak super.hashable;
      # regex-tdfa = lib.doJailbreak super.regex-tdfa;
      # not there?
      # text = self.callHackage "text" "2.0.1" {};
      # doctest-parallel = lib.dontCheck super.doctest-parallel;
      # Atm Nix breaks this.
      # haskell-src-meta = self.callHackage "haskell-src-meta" "0.8.8" {};
      # not yet released
      doctest = self.callCabal2nix "doctest" (builtins.fetchGit {
        url = "https://github.com/eddiejessup/doctest.git";
        ref = "ghc94";
        rev = "400c782c6c4f06988e236abfe85976b911240fbe";
      }) {};
      ilist = lib.doJailbreak super.ilist;
      other924 = lib.dontHaddock (self.callCabal2nix "other924" (gitignore ./.) {});
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.other924
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f); do krank $i; done
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
