{ nixpkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/master.tar.gz") {},
  compiler ? "ghc921" }:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      tumblr-editor = self.callCabal2nix "tumblr-editor" (gitignore ./.) {};
      colourista = lib.doJailbreak super.colourista;
      webdriver = self.callCabal2nix "webdriver" (builtins.fetchGit {
        url = "https://github.com/danwdart/hs-webdriver.git";
        rev = "52a82be322cbb8ee8e65f87056827a3b89277e2a";
      }) {};
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.tumblr-editor
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f); do krank $i; done
    '';
    buildInputs = with myHaskellPackages; with nixpkgs; [
      haskellPackages.apply-refact # not on ghc 9.2 because of ghc-exactprint
      cabal-install
      ghcid
      haskell-language-server
      haskellPackages.hasktags # not on ghc 9.2 because of ghc-exactprint
      hlint
      implicit-hie
      krank
      haskellPackages.stan # base64 issues
      stylish-haskell
      haskellPackages.weeder # not on ghc 9.2 because of generic-lens-core issues
    ];
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.tumblr-editor);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  tumblr-editor = myHaskellPackages.tumblr-editor;
}
