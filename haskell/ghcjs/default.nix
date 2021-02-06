{ system ? builtins.currentSystem }:
(import ./reflex-platform { inherit system; }).project ({ pkgs, ... }: {
  packages = {
    ghcjs-stuff = ./ghcjs-stuff;
    jsaddle-stuff = ./jsaddle-stuff;
    misostuff = ./misostuff;
    reflexstuff = ./reflexstuff;
  };

  shells = {
    ghc = ["jsaddle-stuff" "reflexstuff"];
    ghcjs = ["ghcjs-stuff" "jsaddle-stuff" "misostuff" "reflexstuff"];
  };
})