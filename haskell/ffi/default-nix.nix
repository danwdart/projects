{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  compiler ? "ghc910"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.pkgs.haskell.lib;
  tools = haskell-tools compiler;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      ffi-quickcheck = lib.dontHaddock (lib.doCheck (self.callCabal2nix "ffi-quickcheck" (gitignore ./.) {}));
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.ffi-quickcheck
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done
    '';
     buildInputs = tools.defaultBuildTools ++ [ nixpkgs.haskell.packages.${compiler}.c2hs nixpkgs.haskell.packages.${compiler}.hsc2hs ];
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.ffi-quickcheck);
in
{
  inherit shell;
  ffi-quickcheck = lib.justStaticExecutables (myHaskellPackages.ffi-quickcheck);
}
