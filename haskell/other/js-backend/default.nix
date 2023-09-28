{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  compiler ? "ghcHEAD"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  tools = haskell-tools compiler;
  lib = nixpkgs.pkgsCross.ghcjs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgsCross.ghcjs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      
      js-backend = lib.dontHaddock (self.callCabal2nix "js-backend" (gitignore ./.) {});
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.js-backend
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools ++ (with nixpkgs; [
        nodejs_20
        closurecompiler
    ]);
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.js-backend);
in
{
  inherit shell;
  js-backend = lib.justStaticExecutables (myHaskellPackages.js-backend);
}
