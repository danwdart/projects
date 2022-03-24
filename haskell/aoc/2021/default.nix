{ nixpkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/haskell-updates.tar.gz") {},
  haskell-tools ? import (builtins.fetchTarball "https://github.com/danwdart/haskell-tools/archive/master.tar.gz") {},
  compiler ? "ghc922"
}:
let
  gitignore = nixpkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];
  lib = nixpkgs.pkgs.haskell.lib;
  tools = haskell-tools compiler;
  myHaskellPackages = nixpkgs.pkgs.haskell.packages.${compiler}.override {
    overrides = self: super: rec {
      aoc2021 = lib.dontHaddock (self.callCabal2nix "aoc2021" (gitignore ./.) {});
      # for stan
      cabal-doctest = lib.doJailbreak (self.callCabal2nix "cabal-doctest" (builtins.fetchGit {
        url = "https://github.com/haskellari/cabal-doctest.git";
        rev = "2338f86cbba06366fca42f7c9640bc408c940e0b";
      }) {});
      colourista = lib.doJailbreak super.colourista;
    };
  };
  shell = myHaskellPackages.shellFor {
    packages = p: [
      p.aoc2021
    ];
    buildInputs = tools.defaultBuildTools;
    # withHoogle = false;
  };
  exe = lib.justStaticExecutables (myHaskellPackages.aoc2021);
in
{
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  aoc2021 = myHaskellPackages.aoc2021;
}
