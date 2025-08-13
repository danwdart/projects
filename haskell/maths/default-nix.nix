{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    inherit nixpkgs;
    inherit compiler;
  },
  compiler ? "ghc912"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  tools = haskell-tools compiler;
  inherit (nixpkgs.pkgs.haskell) lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      digits = (self.callHackage "digits" "0.3.1" {}).overrideDerivation (self: {
        prePatch = ''
          echo -e "> import Distribution.Simple\n> main = defaultMain" > Setup.lhs
        '';
      });

      # https://github.com/mvr/cf/issues/4
      cf = lib.dontCheck (lib.markUnbroken super.cf);

      factory = lib.dontCheck (lib.markUnbroken super.factory);

      # not in nix and callHackage didn't work
      partial-isomorphisms = self.callHackageDirect {
        pkg = "partial-isomorphisms";
        ver = "0.2.4.0";
        sha256 = "sha256-JvIo+FJv5P6s124o+WKjclrnyy1/pslxAMsxrg87oEg=";
      } {};

      maths = lib.dontHaddock (self.callCabal2nix "maths" (gitignore ./.) {});
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.maths
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find . -type f | grep -v "dist-*"); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools;
    withHoogle = false;
  };
  exe = lib.justStaticExecutables myHaskellPackages.maths;
in
{
  inherit shell;
  maths = lib.justStaticExecutables myHaskellPackages.maths;
}
