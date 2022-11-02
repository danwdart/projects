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
      whatcoffee = lib.dontHaddock (self.callCabal2nix "whatcoffee" (gitignore ./.) {});
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.whatcoffee
    ];
    buildInputs = tools.defaultBuildTools;
    # withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.whatcoffee);
in
{
  inherit shell;
  whatcoffee = lib.justStaticExecutables (myHaskellPackages.whatcoffee);
}
