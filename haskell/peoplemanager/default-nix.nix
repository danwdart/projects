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
      #brick = lib.doJailbreak super.brick;
      #string-qq = lib.doJailbreak super.string-qq;
      # nixpkgs only has 5.33
      #vty = lib.doJailbreak (self.callHackage "vty" "5.37" {});
      peoplemanager = lib.dontHaddock (self.callCabal2nix "peoplemanager" (gitignore ./.) {});
      pcre-heavy = lib.dontCheck super.pcre-heavy;
      string-random = lib.doJailbreak super.string-random;
      uuid = lib.doJailbreak super.uuid;
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.peoplemanager
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find . -type f | grep -v "dist-*"); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools;
    withHoogle = false;
  };
  exe = lib.justStaticExecutables myHaskellPackages.peoplemanager;
in
{
  inherit shell;
  peoplemanager = lib.justStaticExecutables myHaskellPackages.peoplemanager;
}