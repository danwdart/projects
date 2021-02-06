{ system ? builtins.currentSystem }:
(import ./reflex-platform {
  inherit system;
  config.android_sdk.accept_license = true;
}).project ({ pkgs, ... }: {
  packages = {
    ghcjs-stuff = ./ghcjs-stuff;
    jsaddle-stuff = ./jsaddle-stuff;
    misostuff = ./misostuff;
    reflexstuff = ./reflexstuff;
  };

  # useWarp = true;

  android.reflexstuff = {
    executableName = "dom";
    applicationId = "com.jolharg.reflexstuff";
    displayName = "Reflex Stuff";
  };

  shells = {
    ghc = ["jsaddle-stuff" "reflexstuff"];
    ghcjs = ["ghcjs-stuff" "jsaddle-stuff" "misostuff" "reflexstuff"];
  };
})