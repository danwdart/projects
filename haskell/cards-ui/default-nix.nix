{ system ? builtins.currentSystem,
  nixpkgs ? import <nixpkgs> {},
  lib ? nixpkgs.pkgs.haskell.lib }:
(import ./external/reflex-platform {
  inherit system;
  config.android_sdk.accept_license = true;
}).project ({ pkgs, ... }: {
  packages = {
    cards-ui = ./.;
  };

  shellToolOverrides = ghc: super: {
    inherit (nixpkgs.haskellPackages) apply-refact stylish-haskell wai-app-static;
    inherit (nixpkgs) inotify-tools;
  };

  overrides = self: super: {
    # reactive-banana = self.callHackage "reactive-banana" "1.2.2.0" {};
  };

  useWarp = true;
  withHoogle = false;

  android = {
    cards-ui = {
      executableName = "cards-ui";
      applicationId = "com.jolharg.cards.ui";
      displayName = "Cards";
    };
  };

  shells = {
    ghc = ["cards-ui"];
    ghcjs = ["cards-ui"];
    wasm = ["cards-ui"];
  };
})