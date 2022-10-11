{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  compiler ? "ghc902"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  tools = haskell-tools compiler;
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      inline-asm = self.callHackage "inline-asm" "0.4.0.2" {};
      # https://github.com/brendanhay/gogol/issues/148
      #gogol-core = self.callCabal2nixWithOptions "gogol-core" (builtins.fetchGit { # not yet released
      #  url = "https://github.com/brendanhay/gogol";
      #  rev = "d7c7d71fc985cd96fb5f05173da6c607da362b74";
      #}) "--subpath core" {};
      patch = lib.doJailbreak super.patch;
      dbus = lib.doJailbreak super.dbus;
      reflex-gloss = self.callCabal2nix "reflex-gloss" (builtins.fetchGit {
        url = "https://github.com/noughtmare/reflex-gloss.git";
        ref = "2fbc06753a212d4035886ba8654d33cf373aeb53";
      }) {};
      other902 = lib.dontHaddock (self.callCabal2nix "other902" (gitignore ./.) {});
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.other902
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools;
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.other902);
in
{
  inherit shell;
  other902 = lib.justStaticExecutables (myHaskellPackages.other902);
}