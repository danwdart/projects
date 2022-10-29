{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  # integer-roots doesn't support ghc 9.4 because ghc-bignum < 1.3
  compiler ? "ghc924"
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
      factory = self.callHackage "factory" "0.3.2.3" {};
      partial-isomorphisms = self.callHackage "partial-isomorphisms" "0.2.3.0" {};
      exact-pi = lib.doJailbreak super.exact-pi;
      text-short = lib.overrideCabal super.text-short (drv: {
        doCheck = false;
      });
      modern-uri = lib.doJailbreak super.modern-uri;
      wl-pprint-text = lib.doJailbreak super.wl-pprint-text;
      graphviz = lib.doJailbreak super.graphviz;
      cf = lib.dontCheck (lib.markUnbroken super.cf);

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
