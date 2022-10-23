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
      fakedata = self.callHackage "fakedata" "1.0.2" {};
      brick = lib.doJailbreak super.brick;
      # not yet released
      string-qq = lib.doJailbreak super.string-qq;
      vty = lib.doJailbreak (self.callHackage "vty" "5.37" {});
      doctest = self.callCabal2nix "doctest" (builtins.fetchGit {
        url = "https://github.com/sol/doctest.git";
        rev = "495a76478d63a31c61523b1a539f49340e6be122";
      }) {};
      peoplemanager = lib.dontHaddock (self.callCabal2nix "peoplemanager" (gitignore ./.) {});
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.peoplemanager
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools;
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.peoplemanager);
in
{
  inherit shell;
  peoplemanager = lib.justStaticExecutables (myHaskellPackages.peoplemanager);
}