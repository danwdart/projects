{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  compiler ? "ghc912",
  ENV ? "Unset"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  tools = haskell-tools compiler;
  lib = nixpkgs.pkgsCross.ghcjs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgsCross.ghcjs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      js-backend = (lib.dontHaddock (self.callCabal2nix "js-backend" (gitignore ./.) {})).overrideAttrs(oldEnv: {
        ENV = ENV;
      });
      ghcjs-stuff = lib.dontHaddock (self.callCabal2nix "ghcjs-stuff" (gitignore ./ghcjs-stuff) {});
      # reflex-stuff = lib.dontHaddock (self.callCabal2nix "reflex-stuff" (gitignore ./reflex-stuff) {});
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.js-backend
      p.ghcjs-stuff
      # p.reflex-stuff
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done
    '';
    nativeBuildInputs = tools.defaultBuildTools ++ (with nixpkgs; [
        nodejs_20
        closurecompiler
    ]);
    withHoogle = false;
  };
in
{
  inherit shell;
  js-backend = lib.justStaticExecutables (myHaskellPackages.js-backend);
  ghcjs-stuff = lib.justStaticExecutables (myHaskellPackages.ghcjs-stuff);
  # reflex-stuff = lib.justStaticExecutables (myHaskellPackages.reflex-stuff);
}
