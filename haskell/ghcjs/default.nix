{ system ? builtins.currentSystem,
  nixpkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/haskell-updates.tar.gz") {},
  lib ? nixpkgs.pkgs.haskell.lib }:
(import ./external/reflex-platform {
  inherit system;
  config.android_sdk.accept_license = true;
}).project ({ pkgs, ... }: {
  packages = {
    ghcjs-stuff = ./ghcjs-stuff;
    jsaddle-stuff = ./jsaddle-stuff;
    reflex-stuff = ./reflex-stuff;
  };

  shellToolOverrides = ghc: super: {
    inherit (nixpkgs.haskellPackages) apply-refact stylish-haskell wai-app-static;
    inherit (nixpkgs) inotify-tools;
  };

  overrides = self: super: {
    # ghcjs = nixpkgs.haskell.compilers.ghcjs810
    # In pqueue 1.4.1.3, files are missing
    pqueue = self.callHackage "pqueue" "1.4.1.4" {};
    reactive-banana = self.callHackage "reactive-banana" "1.2.2.0" {};
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
    ghc = ["jsaddle-stuff" "reflex-stuff"];
    ghcjs = ["ghcjs-stuff" "jsaddle-stuff" "reflex-stuff"];
    wasm = ["ghcjs-stuff" "jsaddle-stuff" "reflex-stuff"];
  };
})