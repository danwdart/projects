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
      reflex-headless = lib.dontHaddock (self.callCabal2nix "reflex-headless" (gitignore ./.) {});
      reflex = self.callCabal2nix "reflex" (nixpkgs.fetchFromGitHub {
        owner = "ymeister";
        repo = "reflex";
        rev = "844d88d10cbf0db8ad8677a9c72f6a10e811c0f4";
        sha256 = "EIMAtC4q+zvpckisAp6W1I8S4Lk1f70Yaii0tIhScQQ=";
      }) {};
      patch = lib.doJailbreak super.patch;
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.reflex-headless
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find . -type f | grep -v "dist-*"); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools;
    withHoogle = false;
  };
  exe = lib.justStaticExecutables myHaskellPackages.reflex-headless;
in
{
  inherit shell;
  reflex-headless = lib.justStaticExecutables myHaskellPackages.reflex-headless;
}