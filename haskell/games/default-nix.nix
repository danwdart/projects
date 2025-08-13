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
  inherit (nixpkgs.pkgs.haskell) lib;
  tools = haskell-tools compiler;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      games = lib.dontHaddock (self.callCabal2nix "games" (gitignore ./.) {});
      universe-base = lib.doJailbreak super.universe-base;
      reverse-instances = lib.doJailbreak super.reverse-instances;
      universe-reverse-instances = lib.doJailbreak super.universe-reverse-instances;
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.games
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find . -type f | grep -v "dist-*"); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools;
    withHoogle = false;
  };
  exe = lib.justStaticExecutables myHaskellPackages.games;
in
{
  inherit shell;
  games = lib.justStaticExecutables myHaskellPackages.games;
}
