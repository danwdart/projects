{ nixpkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {},
  compiler ? "ghc921" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      bmp = lib.doJailbreak super.bmp;
      carray = lib.doJailbreak super.carray;
      flow = lib.doJailbreak super.flow;
      OpenGLRaw = lib.doJailbreak super.OpenGLRaw;
      OpenGL = lib.doJailbreak super.OpenGL;
      gloss-rendering = lib.doJailbreak super.gloss-rendering;
      gloss = lib.doJailbreak super.gloss;
      # 3.9.0 only in Nix
      req = lib.doJailbreak (self.callHackage "req" "3.9.2" {});
      readable = lib.doJailbreak super.readable;
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
      # Atm Nix breaks this.
      haskell-src-meta = self.callHackage "haskell-src-meta" "0.8.8" {};
      other921 = self.callCabal2nix "other921" (gitignore ./.) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.other921
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
      haskellPackages.weeder # not on ghc 9.2 because of generic-lens-core issues
    ];
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.other921);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  other921 = myHaskellPackages.other921;
}
