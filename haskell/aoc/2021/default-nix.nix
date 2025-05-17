{ nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  compiler ? "ghc912"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.pkgs.haskell.lib;
  tools = haskell-tools compiler;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      aoc2021 = lib.dontHaddock (self.callCabal2nix "aoc2021" (gitignore ./.) {});
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.aoc2021
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools;
    # withHoogle = false;
  };
  in
{
  inherit shell;
  aoc2021 = lib.justStaticExecutables (myHaskellPackages.aoc2021);
}
