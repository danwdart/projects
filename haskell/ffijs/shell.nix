# shell.nix
let
  nixpkgs = import <nixpkgs> {};
  project = import ./default.nix;
in
  project.shellFor {
    packages = ps: with ps; [
    ];

    withHoogle = false;

    tools = {
      cabal = "3.2.0.0";
      hlint = "latest";
      haskell-language-server = "latest";
    };

    buildInputs = with nixpkgs; [
      git
      nodejs
    ];

    crossPlatforms = ps: with ps; [
      ghcjs
    ];

    exactDeps = true;
  }
