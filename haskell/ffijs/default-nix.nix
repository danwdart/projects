{ system ? builtins.currentSystem,
  nixpkgs ? import <nixpkgs> {},
  lib ? nixpkgs.pkgs.haskell.lib }:
(import ./external/reflex-platform {
  inherit system;
  config.android_sdk.accept_license = true;
}).project ({ pkgs, ... }: {
  packages = {
    ffijs = ./.;
  };

  shellToolOverrides = ghc: super: {
    inherit (nixpkgs.haskellPackages) apply-refact stylish-haskell;
    inherit (nixpkgs) inotify-tools;
  };

  overrides = self: super: {
  };

  useWarp = false;
  withHoogle = false;

  android = {
    ffihs = {
      executableName = "ffijs";
      applicationId = "com.jolharg.ffijs.ffijs";
      displayName = "Reflex ffijs";
    };
  };

  shells = {
    ghc = ["ffijs"];
    ghcjs = ["ffijs"];
    wasm = ["ffijs"];
  };
})