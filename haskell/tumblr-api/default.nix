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
      humblr = self.callCabal2nix "humblr" (builtins.fetchGit {
        url = "https://github.com/danwdart/humblr.git";
        rev = "22b065ead87cb1c3c19545c54f8ff90fb1e314e9";
      }) {};
      # https://github.com/AndrewRademacher/aeson-casing/issues/7
      #aeson-casing = lib.dontCheck super.aeson-casing;
      tumblr-api = lib.dontHaddock (self.callCabal2nix "tumblr-api" (gitignore ./.) {});
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.tumblr-api
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools;
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.tumblr-api);
in
{
  inherit shell;
  tumblr-api = lib.justStaticExecutables (myHaskellPackages.tumblr-api);
}
