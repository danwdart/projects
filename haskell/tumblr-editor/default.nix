{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  compiler ? "ghc94"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  tools = haskell-tools compiler;
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      tumblr-editor = lib.dontHaddock (self.callCabal2nix "tumblr-editor" (gitignore ./.) {});
      colourista = lib.doJailbreak super.colourista;
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.tumblr-editor
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v dist-newstyle); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools;
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.tumblr-editor);
in
{
  inherit shell;
  tumblr-editor = lib.justStaticExecutables (myHaskellPackages.tumblr-editor);
}
