{ system ? builtins.currentSystem }:
(import ./reflex-platform {
  inherit system;
  config.android_sdk.accept_license = true;
}).project ({ pkgs, ... }: {
  packages = {
    base-stuff = ./base-stuff;
    ghcjs-stuff = ./ghcjs-stuff;
    jsaddle-stuff = ./jsaddle-stuff;
    misostuff = ./misostuff;
    reflexstuff = ./reflexstuff;
  };

  # useWarp = true;

  android.misostuff = {
    executableName = "misostuff";
    applicationId = "com.jolharg.misostuff";
    displayName = "Miso Stuff";
  };

  android.reflexstuff = {
    executableName = "dom";
    applicationId = "com.jolharg.reflexstuff";
    displayName = "Reflex Stuff";
  };

  shells = {
    ghc = ["basestuff" "jsaddle-stuff" "reflexstuff"];
    ghcjs = ["basestuff" "ghcjs-stuff" "jsaddle-stuff" "misostuff" "reflexstuff"];
    wasm = ["basestuff" "ghcjs-stuff" "jsaddle-stuff" "misostuff" "reflexstuff"];
  };
})