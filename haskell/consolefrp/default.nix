{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  # https://github.com/reflex-frp/patch/issues/42
  compiler ? "ghc902"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  tools = haskell-tools compiler;
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      consolefrp = lib.dontHaddock (self.callCabal2nix "consolefrp" (gitignore ./.) {});
      # 9.0.2 -> 9.2.2
      # monoidal-containers = lib.doJailbreak super.monoidal-containers;
      # patch = lib.doJailbreak super.patch;
      reflex-vty = lib.doJailbreak (lib.markUnbroken super.reflex-vty); # self.callHackage "reflex-vty"
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.consolefrp
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools;
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.consolefrp);
in
{
  inherit shell;
  consolefrp = lib.justStaticExecutables (myHaskellPackages.consolefrp);
}