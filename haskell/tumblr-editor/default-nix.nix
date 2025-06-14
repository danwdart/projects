{
  nixpkgs ? import <nixpkgs> {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {
    nixpkgs = nixpkgs;
    compiler = compiler;
  },
  compiler ? "ghc912"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  tools = haskell-tools compiler;
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      tumblr-editor = lib.dontHaddock (self.callCabal2nix "tumblr-editor" (gitignore ./.) {});
      # webdriver = self.callHackage "webdriver" "0.11.0.0" {};
      #colourista = lib.doJailbreak super.colourista;
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.tumblr-editor
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f | grep -v "dist-*"); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools;
    withHoogle = false;
  };
  in
{
  inherit shell;
  tumblr-editor = lib.justStaticExecutables (myHaskellPackages.tumblr-editor);
}
