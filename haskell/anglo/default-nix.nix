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
  inherit (nixpkgs.pkgs.haskell) lib;
  tools = haskell-tools compiler;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      anglo = lib.dontHaddock (self.callCabal2nix "anglo" (gitignore ./.) {});
      universe-base = lib.doJailbreak super.universe-base;
      reverse-instances = lib.doJailbreak super.reverse-instances;
      universe-reverse-instances = lib.doJailbreak super.universe-reverse-instances;
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.anglo
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find . -type f | grep -v "dist-*"); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools;
    withHoogle = false;
  };
  exe = lib.justStaticExecutables myHaskellPackages.anglo;
in
{
  inherit shell;
  anglo = lib.justStaticExecutables myHaskellPackages.anglo;
}
