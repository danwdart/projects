{ system ? builtins.currentSystem,
  nixpkgs ? import <nixpkgs> {},
  lib ? nixpkgs.pkgs.haskell.lib }:
(import ./external/reflex-platform {
  inherit system;
  config.android_sdk.accept_license = true;
}).project ({ pkgs, ... }: {
  packages = {
    ghcjs-stuff = ./ghcjs-stuff;
    reflex-stuff = ./reflex-stuff;
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
    reflex-stuff = {
      executableName = "dom";
      applicationId = "com.jolharg.reflexstuff.dom";
      displayName = "Reflex DOM Demo";
    };
  };

  shells = {
    ghc = ["reflex-stuff"];
    ghcjs = ["ghcjs-stuff" "reflex-stuff"];
    wasm = ["ghcjs-stuff" "reflex-stuff"];
  };
})