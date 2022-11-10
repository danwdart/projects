{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  # https://github.com/0xd34df00d/inline-asm/issues/4
  compiler ? "ghc92"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  tools = haskell-tools compiler;
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      inline-asm = lib.markUnbroken super.inline-asm;
      other92 = lib.dontHaddock (self.callCabal2nix "other92" (gitignore ./.) {});
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.other92
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools ++ [ nixpkgs.gettext ];
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.other92);
in
{
  inherit shell;
  other92 = lib.justStaticExecutables (myHaskellPackages.other92);
}
