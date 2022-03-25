{
  nixpkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/haskell-updates.tar.gz") {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {},
  # https://github.com/reflex-frp/patch/issues/42
  compiler ? "ghc902"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  tools = haskell-tools compiler;
  lib = nixpkgs.pkgs.haskell.lib;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      reflex-headless = lib.dontHaddock (self.callCabal2nix "reflex-headless" (gitignore ./.) {});
      # 9.0.2 -> 9.2.2
      # monoidal-containers = lib.doJailbreak super.monoidal-containers;
      # patch = lib.doJailbreak super.patch;
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.reflex-headless
    ];
    shellHook = ''
      gen-hie > hie.yaml
      for i in $(find -type f); do krank $i; done
    '';
    buildInputs = tools.defaultBuildTools;
    withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.reflex-headless);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  reflex-headless = myHaskellPackages.reflex-headless;
}