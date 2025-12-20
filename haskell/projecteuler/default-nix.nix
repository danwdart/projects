{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    inherit nixpkgs;
    inherit compiler;
  },
  compiler ? "ghc914"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  tools = haskell-tools compiler;
  inherit (nixpkgs.pkgs.haskell) lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      projecteuler = lib.dontHaddock (self.callCabal2nix "projecteuler" (gitignore ./.) {});
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.projecteuler
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find . -type f | grep -v "dist-*"); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools;
    withHoogle = false;
  };
  exe = lib.justStaticExecutables myHaskellPackages.projecteuler;
in
{
  inherit shell;
  projecteuler = lib.justStaticExecutables myHaskellPackages.projecteuler;
}
