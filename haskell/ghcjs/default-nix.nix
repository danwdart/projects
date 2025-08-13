{ system ? builtins.currentSystem,
  nixpkgs ? import <nixpkgs> {},
  lib ? nixpkgs.pkgs.haskell.lib,
  ENV ? "Unset env"
}:
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
    ghcjs-stuff = super.ghcjs-stuff.overrideAttrs(oldEnv: { inherit ENV; });
    # reactive-banana = self.callHackage "reactive-banana" "1.2.2.0" {};
  };

  useWarp = true;
  withHoogle = false;

  android = {
    ghcjs-stuff = {
      executableName = "mine";
      applicationId = "com.jolharg.ghcjsstuff.mine";
      displayName = "GHCJS Stuff - Mine";
    };
    reflex-stuff = {
      executableName = "dom";
      applicationId = "com.jolharg.reflexstuff.dom";
      displayName = "Reflex Stuff - DOM";
    };
  };

  shells = {
    android = ["ghcjs-stuff" "reflex-stuff"];
    ghc = ["ghcjs-stuff" "reflex-stuff"];
    ghcjs = ["ghcjs-stuff" "reflex-stuff"];
    wasm = ["ghcjs-stuff" "reflex-stuff"];
  };
})