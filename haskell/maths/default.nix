{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  # integer-roots doesn't support ghc 9.4 because ghc-bignum < 1.3
  # https://github.com/Bodigrim/integer-roots/issues/2
  compiler ? "ghc92"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  tools = haskell-tools compiler;
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      digits = (self.callHackage "digits" "0.3.1" {}).overrideDerivation (self: {
        prePatch = ''
          echo -e "> import Distribution.Simple\n> main = defaultMain" > Setup.lhs
        '';
      });

      # https://github.com/mvr/cf/issues/4
      cf = lib.dontCheck (lib.markUnbroken super.cf);

      factory = lib.markUnbroken super.factory;

      maths = lib.dontHaddock (self.callCabal2nix "maths" (gitignore ./.) {});
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.maths
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools;
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.maths);
in
{
  inherit shell;
  maths = lib.justStaticExecutables (myHaskellPackages.maths);
}
