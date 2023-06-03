{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  compiler ? "ghc92"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  tools = haskell-tools compiler;
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      archery = lib.doBenchmark (lib.doCheck (lib.dontHaddock (self.callCabal2nix "archery" (gitignore ./.) {})));
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.archery
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools ++ [ nixpkgs.gettext nixpkgs.nodejs_20 nixpkgs.php82 ];
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.archery);
in
{
  inherit shell;
  archery = lib.justStaticExecutables (myHaskellPackages.archery);
}
