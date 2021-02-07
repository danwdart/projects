{ system ? builtins.currentSystem }:
(import ./reflex-platform {
  inherit system;
  config.android_sdk.accept_license = true;
}).project ({ pkgs, ... }: {
  packages = {
    base-stuff = ./base-stuff;
    ghcjs-stuff = ./ghcjs-stuff;
    jsaddle-stuff = ./jsaddle-stuff;
    reflexstuff = ./reflexstuff;
  };

  # useWarp = true;

  android.reflexstuff = {
    executableName = "dom";
    applicationId = "com.jolharg.reflexstuff";
    displayName = "Reflex Stuff";
  };

  shells = {
    ghc = ["basestuff" "jsaddle-stuff" "reflexstuff"];
    ghcjs = ["basestuff" "ghcjs-stuff" "jsaddle-stuff" "reflexstuff"];
    wasm = ["basestuff" "ghcjs-stuff" "jsaddle-stuff" "reflexstuff"];
  };
})