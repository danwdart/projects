{
  nixpkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/haskell-updates.tar.gz") {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {},
  compiler ? "ghc922"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  tools = haskell-tools compiler;
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      tumblr-editor = lib.dontHaddock (self.callCabal2nix "tumblr-editor" (gitignore ./.) {});
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
    buildInputs = tools.defaultBuildTools;
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
